import math
import random

from config import (
    MIXED_PROFILE_THRESHOLDS,
    HEALTH_IMPAIRED_STATES,
    PROFILE_CONFIGS,
    PROFILE_MEMBERSHIP_POLICY,
    SIMULATION,
    TASK_SUCCESS_PROBABILITY_BY_HEALTH,
)


class SoSCoordinator:
    def __init__(self, env, broker, flood, twins, seed=None):
        self.env = env
        self.broker = broker
        self.flood = flood
        self.twins = {t.name: t for t in twins}
        self.latest = {}
        self.events = []
        self.task_outcome_counts = {
            "attempted": 0,
            "succeeded": 0,
            "failed_health": 0,
            "failed_physical": 0,
            "failed_other": 0,
        }
        self.assignments = {}
        self.random = random.Random(SIMULATION["seed"] if seed is None else seed)
        self.pending_departures = set()
        self.pending_health_departures = set()
        self.health_rejoin_eligible = set()
        self.health_rejoin_ready = set()
        self.last_health_rejoin_attempt = {}
        self.health_rejoin_counts = {
            "eligible_departures": 0,
            "repairs_ready": 0,
            "generated": 0,
            "profile_denied": 0,
            "submitted_to_bm": 0,
            "machine_rejected": 0,
            "completed": 0,
        }
        self._seen_twin_logs = {name: 0 for name in self.twins}
        self.dt_time = 0.0
        self.dt_time_by_asset = {}
        self.active_dt_time = 0.0
        self.active_dt_time_by_asset = {}
        self.pumping_station_active_time = 0.0
        self.pumping_station_service_time = 0.0
        self.pumping_station_health_communication_unavailable_time = 0.0
        self.backup_requests = 0
        self.backup_activations = 0
        self.backup_rescue_time = 0.0
        self.processing_work = 0.0
        self.sos_request_counts = {
            "generated": 0,
            "profile_denied": 0,
            "capacity_deferred": 0,
            "submitted_to_bm": 0,
            "completed": 0,
        }
        self.join_request_counts = {
            "generated": 0,
            "profile_denied": 0,
            "submitted_to_bm": 0,
            "machine_rejected": 0,
            "completed": 0,
        }
        self.last_join_attempt = {}
        self.peak_attached_dts = 0
        self.peak_constellation_dts = 0
        self.broker.subscribe("telemetry", self.on_telemetry)
        self.broker.subscribe("task_result", self.on_task_result)

    def on_telemetry(self, payload, source):
        self.latest[source] = payload
        self.events.append(
            {
                "time": self.env.now,
                "event": "telemetry_received",
                "unit": source,
                "health": payload.get("health"),
                "belonging": payload.get("belonging"),
                "connected": payload.get("connected"),
            }
        )

    def on_task_result(self, payload, source):
        result = payload.get("result") or {}
        # This message-level event is useful for communication diagnostics.
        # Run-level task counts are collected from the twin's local log so
        # simulated message loss cannot erase an attempted task from metrics.
        self.events.append(
            {
                "time": self.env.now,
                "event": "task_result_message",
                "unit": source,
                "action": payload.get("action"),
                "result": result,
            }
        )

    def _record_task_outcome(self, result):
        self.task_outcome_counts["attempted"] += 1
        if result.get("executed") is False:
            reason = result.get("failure_reason")
            outcome = {
                "health_state": "failed_health",
                "health_state_probability": "failed_health",
                "health_communication_unavailable": "failed_health",
                "physical_unavailable": "failed_physical",
            }.get(reason, "failed_other")
            self.task_outcome_counts[outcome] += 1
        else:
            self.task_outcome_counts["succeeded"] += 1

    def profile_for(self, twin):
        strategy = SIMULATION["profile_strategy"]
        if strategy == "low_only":
            return "Reactive"
        if strategy == "high_only":
            return "Adaptive"
        if strategy != "mixed":
            raise ValueError(f"Unknown profile strategy: {strategy}")

        water = self.flood.max_water_level
        asset_type = twin.unit.asset_type
        role = twin.unit.role
        # Reserve boats keep the low-cost Reactive profile until activated.
        # Once assigned an operational role, the normal mixed progression is
        # applied; when returned to reserve, this rule restores Reactive.
        if asset_type == "boat" and role == "reserve":
            return "Reactive"

        if asset_type == "drone":
            return (
                "Proactive"
                if water >= MIXED_PROFILE_THRESHOLDS["proactive"]
                else "Reactive"
            )

        if asset_type == "pump":
            if water >= MIXED_PROFILE_THRESHOLDS["controlled"]:
                return "Controlled"
            if water >= MIXED_PROFILE_THRESHOLDS["proactive"]:
                return "Proactive"
            return "Reactive"

        if asset_type == "boat":
            if water >= MIXED_PROFILE_THRESHOLDS["adaptive"] and role == "rescue":
                return "Adaptive"
            if water >= MIXED_PROFILE_THRESHOLDS["controlled"]:
                return "Controlled"
            if water >= MIXED_PROFILE_THRESHOLDS["proactive"]:
                return "Proactive"
        return "Reactive"

    def update_profiles(self):
        for name, twin in self.twins.items():
            target = self.profile_for(twin)
            old = twin.profile
            if twin.set_profile(target):
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "profile_changed",
                        "unit": name,
                        "from": old,
                        "to": target,
                        "strategy": SIMULATION["profile_strategy"],
                        "water_level": self.flood.max_water_level,
                    }
                )

    def _expected_rescues_per_boat(self, time_available, success_probability=1.0):
        time_steps = max(0.0, time_available / SIMULATION["step"])
        area_factor = 1.0 + self.flood.flooded_area * SIMULATION["rescue_area_penalty"]
        return (
            SIMULATION["rescue_capacity_per_boat_step"]
            * time_steps
            * success_probability
            / area_factor
        )

    @staticmethod
    def _task_success_probability(twin):
        return TASK_SUCCESS_PROBABILITY_BY_HEALTH.get(twin.health_state(), 0.0)

    def minimum_rescue_boats(self):
        waiting = [v for v in self.flood.victims if v["status"] == "waiting"]
        if not waiting:
            return 0
        deadlines = sorted({victim["deadline"] for victim in waiting})
        minimum = 0
        for deadline in deadlines:
            due = sum(victim["deadline"] <= deadline for victim in waiting)
            capacity = self._expected_rescues_per_boat(deadline - self.env.now)
            required = math.ceil(due / capacity) if capacity > 0 else len(self.twins) + 1
            minimum = max(minimum, required)
        return minimum

    def _available_boats(self):
        return [
            twin
            for twin in self.twins.values()
            if twin.unit.asset_type == "boat"
            and twin.unit.operational
            and self._task_success_probability(twin) > 0.0
            and twin.connected
            and (
                twin.unit.role == "reserve"
                or (twin.unit.role in {"monitoring", "rescue"} and twin.can_operate)
            )
        ]

    def ensure_rescue_capacity(self):
        required = self.minimum_rescue_boats()
        available_boats = self._available_boats()
        target_capacity = min(
            float(required),
            sum(self._task_success_probability(twin) for twin in available_boats),
        )
        attached_rescue = [
            twin
            for twin in self.twins.values()
            if twin.unit.asset_type == "boat"
            and twin.unit.role == "rescue"
            and twin.can_operate
            and twin.connected
            and self._task_success_probability(twin) > 0.0
        ]
        attached_capacity = sum(self._task_success_probability(twin) for twin in attached_rescue)
        attempted_candidates = set()
        while attached_capacity + 1e-9 < target_capacity:
            candidates = sorted(
                (
                    twin
                    for twin in available_boats
                    if twin not in attached_rescue
                    and twin.name not in attempted_candidates
                    and (
                        (twin.unit.role == "monitoring" and twin.can_operate)
                        or twin.unit.role == "reserve"
                    )
                ),
                key=lambda twin: (
                    -self._task_success_probability(twin),
                    twin.unit.role != "monitoring",
                    not twin.is_attached_to_sos,
                    twin.name,
                ),
            )
            if not candidates:
                break
            twin = candidates[0]
            last_attempt = self.last_join_attempt.get(twin.name, -math.inf)
            if self.env.now - last_attempt < SIMULATION["join_retry_interval"]:
                attempted_candidates.add(twin.name)
                continue
            attempted_candidates.add(twin.name)
            self.last_join_attempt[twin.name] = self.env.now
            if twin.unit.role == "reserve":
                self.backup_requests += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "backup_requested",
                        "unit": twin.name,
                        "reason": "rescue_capacity",
                        "effective_rescue_boat_capacity": round(attached_capacity, 4),
                        "required_rescue_boat_capacity": required,
                    }
                )
            self.join_request_counts["generated"] += 1
            join_request = {
                "time": self.env.now,
                "unit": twin.name,
                "profile": twin.profile,
                "reason": "rescue_capacity",
            }
            self.events.append({"event": "sos_join_request", **join_request})
            policy = PROFILE_MEMBERSHIP_POLICY[twin.profile]
            if self.random.random() >= policy["join_acceptance"]:
                self.join_request_counts["profile_denied"] += 1
                self.events.append({"event": "sos_join_denied_by_profile", **join_request})
                continue

            previous_role = twin.unit.role
            twin.unit.set_role("rescue")
            self.join_request_counts["submitted_to_bm"] += 1
            joined = twin.join_sos(join_constellation=True)
            if not joined:
                twin.unit.set_role(previous_role)
                self.join_request_counts["machine_rejected"] += 1
                self.events.append({"event": "sos_join_rejected_by_machine", **join_request})
                continue
            self.join_request_counts["completed"] += 1
            self.update_profiles_for(twin)
            self.assignments[twin.name] = "rescue"
            self.events.append(
                {
                    "time": self.env.now,
                    "event": "boat_activated_for_rescue",
                    "unit": twin.name,
                    "previous_role": previous_role,
                }
            )
            if twin.can_operate and twin.connected and self._task_success_probability(twin) > 0.0:
                attached_rescue.append(twin)
                attached_capacity += self._task_success_probability(twin)
                if previous_role == "reserve":
                    self.backup_activations += 1
                    self.events.append(
                        {
                            "time": self.env.now,
                            "event": "backup_activated",
                            "unit": twin.name,
                            "role": "rescue",
                        }
                    )

        if attached_capacity + 1e-9 < required:
            self.events.append(
                {
                    "time": self.env.now,
                    "event": "rescue_capacity_shortfall",
                    "required_boats": required,
                    "active_rescue_boats": len(attached_rescue),
                    "effective_rescue_boat_capacity": round(attached_capacity, 4),
                    "available_physical_boats": len(available_boats),
                }
            )

        # Release spare capacity to its configured monitoring/reserve role.
        kept_capacity = 0.0
        for twin in sorted(
            attached_rescue,
            key=lambda item: (-self._task_success_probability(item), item.name),
        ):
            if kept_capacity + 1e-9 < target_capacity:
                kept_capacity += self._task_success_probability(twin)
                continue
            original_role = twin.unit.config["role"]
            if original_role in {"monitoring", "reserve"}:
                twin.unit.set_role(original_role)
                self.assignments[twin.name] = original_role
                self.update_profiles_for(twin)

    def update_profiles_for(self, twin):
        target = self.profile_for(twin)
        old = twin.profile
        if twin.set_profile(target):
            self.events.append(
                {
                    "time": self.env.now,
                    "event": "profile_changed",
                    "unit": twin.name,
                    "from": old,
                    "to": target,
                    "strategy": SIMULATION["profile_strategy"],
                    "water_level": self.flood.max_water_level,
                }
            )

    def _active_boat_count(self, excluding=None):
        return sum(
            self._task_success_probability(twin)
            for twin in self.twins.values()
            if twin is not excluding
            and twin.unit.asset_type == "boat"
            and twin.unit.role != "reserve"
            and twin.can_operate
            and twin.connected
        )

    def process_voluntary_departures(self):
        step = SIMULATION["step"]
        for twin in self.twins.values():
            if twin.name in self.pending_departures or not twin.is_in_constellation:
                continue
            configuration = PROFILE_CONFIGS[SIMULATION["profile_configuration"]]
            rate = configuration[twin.profile]["departure_rate"]
            probability = 1.0 - math.exp(-rate * step)
            if self.random.random() >= probability:
                continue

            self.sos_request_counts["generated"] += 1
            policy = PROFILE_MEMBERSHIP_POLICY[twin.profile]
            request = {
                "time": self.env.now,
                "unit": twin.name,
                "profile": twin.profile,
                "rate": rate,
                "reason": "sos_autonomy",
            }
            self.events.append({"event": "sos_departure_request", **request})
            if self.random.random() >= policy["leave_acceptance"]:
                self.sos_request_counts["profile_denied"] += 1
                self.events.append({"event": "sos_departure_denied_by_profile", **request})
                continue

            required = self.minimum_rescue_boats()
            remaining_boats = self._active_boat_count(excluding=twin)
            if remaining_boats < required:
                self.sos_request_counts["capacity_deferred"] += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "sos_departure_deferred_for_capacity",
                        "unit": twin.name,
                        "reason": "sos",
                        "profile": twin.profile,
                        "minimum_boats": required,
                        "boats_after_departure": remaining_boats,
                    }
                )
                continue

            raised = twin.leave_constellation("sos")
            if raised:
                self.pending_departures.add(twin.name)
                self.sos_request_counts["submitted_to_bm"] += 1
            self.events.append({"event": "sos_departure_submitted_to_bm", **request, "event_raised": raised})

    def observe_state_changes(self):
        for name, twin in self.twins.items():
            start = self._seen_twin_logs[name]
            new_entries = twin.log[start:]
            self._seen_twin_logs[name] = len(twin.log)
            for entry in new_entries:
                if entry.get("event") == "state_transition":
                    self.events.append({"unit": name, **entry})
                    before = entry.get("from", {})
                    after = entry.get("to", {})
                    cause = str(entry.get("cause", ""))
                    health_event = cause.startswith(("health:", "environmental_fault:")) or (
                        cause.startswith("profile_reconfiguration:")
                        and before.get("health") in HEALTH_IMPAIRED_STATES
                    )
                    if health_event and before.get("belonging") == "Active":
                        self.pending_health_departures.add(name)
                    left_active_membership = (
                        before.get("belonging") == "Active"
                        and after.get("belonging") != "Active"
                    )
                    if left_active_membership:
                        if name in self.pending_health_departures or health_event:
                            health = after.get("health", "Unknown")
                            self.pending_health_departures.discard(name)
                            if name not in self.health_rejoin_eligible:
                                self.health_rejoin_counts["eligible_departures"] += 1
                            self.health_rejoin_eligible.add(name)
                            self.events.append(
                                {
                                    "time": entry.get("time", self.env.now),
                                    "event": "health_related_departure",
                                    "unit": name,
                                    "health": health,
                                    "profile": twin.profile,
                                    "from_belonging": before.get("belonging"),
                                    "to_belonging": after.get("belonging"),
                                }
                            )
                elif entry.get("event") == "task_attempt_result":
                    self._record_task_outcome(entry.get("result") or {})
                    self.events.append(
                        {
                            "time": entry.get("time", self.env.now),
                            "event": "task_attempt_result",
                            "unit": name,
                            "task": entry.get("task"),
                            "health": entry.get("health"),
                            "result": entry.get("result"),
                        }
                    )
                elif entry.get("event") == "health_communication_changed":
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "repair_preparation_requested":
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "repair_requested":
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "repair_completed" and name in self.health_rejoin_eligible:
                    if name not in self.health_rejoin_ready:
                        self.health_rejoin_counts["repairs_ready"] += 1
                    self.health_rejoin_ready.add(name)
            if name in self.pending_departures and not twin.is_in_constellation:
                # Some generated machines complete their exit in a later timer cycle.
                self.pending_departures.remove(name)
                self.sos_request_counts["completed"] += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "sos_departure_completed",
                        "unit": name,
                        "profile": twin.profile,
                        "belonging": twin.belonging_state(),
                    }
                )

    def process_health_rejoins(self):
        """Re-admit repaired health-withdrawn twins through their generated bm."""
        if SIMULATION["profile_strategy"] not in {"high_only", "mixed"}:
            return
        for name in list(self.health_rejoin_ready):
            twin = self.twins[name]
            if twin.is_in_constellation:
                self.health_rejoin_ready.discard(name)
                self.health_rejoin_eligible.discard(name)
                self.health_rejoin_counts["completed"] += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "health_rejoin_completed",
                        "unit": name,
                        "profile": twin.profile,
                        "path": "generated_recovery",
                    }
                )
                continue
            if twin.health_state() != "Ideal" or not twin.unit.operational:
                continue

            last_attempt = self.last_health_rejoin_attempt.get(name, -math.inf)
            retry_interval = SIMULATION["health_rejoin_retry_interval"]
            if self.env.now - last_attempt < retry_interval:
                continue
            self.last_health_rejoin_attempt[name] = self.env.now
            request = {
                "time": self.env.now,
                "unit": name,
                "profile": twin.profile,
                "reason": "health_recovery",
            }
            self.health_rejoin_counts["generated"] += 1
            self.events.append({"event": "health_rejoin_request", **request})
            policy = PROFILE_MEMBERSHIP_POLICY[twin.profile]
            if self.random.random() >= policy["join_acceptance"]:
                self.health_rejoin_counts["profile_denied"] += 1
                self.events.append({"event": "health_rejoin_denied_by_profile", **request})
                continue

            self.health_rejoin_counts["submitted_to_bm"] += 1
            joined = twin.join_sos(join_constellation=True)
            if joined:
                self.health_rejoin_counts["completed"] += 1
                self.health_rejoin_ready.discard(name)
                self.health_rejoin_eligible.discard(name)
                self.events.append({"event": "health_rejoin_completed", **request, "path": "bm_request"})
            else:
                self.health_rejoin_counts["machine_rejected"] += 1
                self.events.append({"event": "health_rejoin_rejected_by_machine", **request})

    def dispatch_tasks(self):
        for twin in self.twins.values():
            twin.last_task_succeeded = False
            # Active but degraded/faulty DTs still receive their assigned task:
            # the physical twin reports the failed outcome, preserving the
            # mission impact rather than silently omitting the DT.
            if not twin.is_in_constellation or not twin.connected or twin.role_restricted:
                continue
            asset_type = twin.unit.asset_type
            role = twin.unit.role
            if asset_type == "drone":
                twin.receive_command({"action": "monitor"})
            elif asset_type == "pump":
                twin.receive_command({"action": "pump", "amount": SIMULATION["pump_reduction_per_step"]})
            elif asset_type == "boat" and role == "rescue":
                twin.receive_command(
                    {
                        "action": "rescue",
                        "capacity": SIMULATION["rescue_capacity_per_boat_step"],
                    }
                )
            elif asset_type == "boat" and role == "monitoring":
                twin.receive_command({"action": "monitor"})

    def _record_resource_time(self):
        attached = [twin for twin in self.twins.values() if twin.is_attached_to_sos]
        active = [twin for twin in self.twins.values() if twin.is_in_constellation]
        self.peak_attached_dts = max(self.peak_attached_dts, len(attached))
        self.peak_constellation_dts = max(self.peak_constellation_dts, len(active))
        self.dt_time += len(attached) * SIMULATION["step"]
        for twin in attached:
            asset_type = twin.unit.asset_type
            self.dt_time_by_asset[asset_type] = self.dt_time_by_asset.get(asset_type, 0.0) + SIMULATION["step"]
        self.active_dt_time += len(active) * SIMULATION["step"]
        for twin in active:
            asset_type = twin.unit.asset_type
            self.active_dt_time_by_asset[asset_type] = (
                self.active_dt_time_by_asset.get(asset_type, 0.0) + SIMULATION["step"]
            )
        pump = self.twins.get("PumpingStation")
        if pump is not None and pump.is_in_constellation:
            self.pumping_station_active_time += SIMULATION["step"]
        if (
            pump is not None
            and pump.can_operate
            and pump.connected
            and pump.last_task_succeeded
        ):
            self.pumping_station_service_time += SIMULATION["step"]
        if pump is not None and not pump.health_communication_available:
            self.pumping_station_health_communication_unavailable_time += SIMULATION["step"]
        for twin in self.twins.values():
            if (
                twin.unit.config.get("role") == "reserve"
                and twin.unit.role == "rescue"
                and twin.is_in_constellation
            ):
                self.backup_rescue_time += SIMULATION["step"]

    def _record_processing_work(self):
        for twin in self.twins.values():
            if twin.connected and twin.is_attached_to_sos:
                multiplier = PROFILE_MEMBERSHIP_POLICY[twin.profile]["processing_work_per_step"]
                self.processing_work += multiplier * SIMULATION["step"]

    def run(self):
        while True:
            self.update_profiles()
            self.ensure_rescue_capacity()
            self.process_voluntary_departures()
            self.dispatch_tasks()
            self.observe_state_changes()
            self.process_health_rejoins()
            self.observe_state_changes()
            self._record_processing_work()
            self._record_resource_time()
            self.assignments = {t.name: t.unit.role for t in self.twins.values()}
            yield self.env.timeout(SIMULATION["step"])

    def metrics(self):
        return {
            "peak_attached_dts": self.peak_attached_dts,
            "peak_constellation_dts": self.peak_constellation_dts,
            "dt_time": self.dt_time,
            "dt_time_by_asset": dict(self.dt_time_by_asset),
            "active_dt_time": self.active_dt_time,
            "active_dt_time_by_asset": dict(self.active_dt_time_by_asset),
            "pumping_station_active_time": self.pumping_station_active_time,
            "pumping_station_service_time": self.pumping_station_service_time,
            "pumping_station_health_communication_unavailable_time": (
                self.pumping_station_health_communication_unavailable_time
            ),
            "backup_activations": self.backup_activations,
            "backup_requests": self.backup_requests,
            "backup_rescue_time": self.backup_rescue_time,
            "processing_work": self.processing_work,
            "sos_request_counts": dict(self.sos_request_counts),
            "join_request_counts": dict(self.join_request_counts),
            "health_rejoin_counts": dict(self.health_rejoin_counts),
            "task_outcome_counts": dict(self.task_outcome_counts),
            "repair_time": sum(twin.repair_time for twin in self.twins.values()),
            "repair_requests": sum(twin.repair_requests for twin in self.twins.values()),
            "repairs_completed": sum(twin.repairs_completed for twin in self.twins.values()),
        }
