import math
import random

from config import (
    MIXED_PROFILE_THRESHOLDS,
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
        # Keep task evidence split by task, role, and health so rescue failures
        # can be compared across profile strategies without changing behavior.
        self.task_outcomes_by_task_role_health = {}
        self.assignments = {}
        self.random = random.Random(SIMULATION["seed"] if seed is None else seed)
        self.pending_departures = set()
        self.departure_request_sequence = 0
        self.departure_retention_episodes = []
        self.open_departure_retention = {}
        self.pending_health_replacements = []
        self.pending_health_exits = {}
        self.health_return_eligible = set()
        self.health_return_ready = set()
        self.last_health_return_attempt = {}
        self.backup_return_pending = set()
        self.recovered_standby_roles = {}
        self.last_standby_activation_attempt = {}
        self.backup_unit_names = {
            twin.name for twin in self.twins.values() if twin.unit.config.get("role") == "reserve"
        }
        self.backup_shortfall_logged = set()
        self.health_lifecycle_counts = {
            "eligible_departures": 0,
            "repairs_ready": 0,
            "replacement_requests": 0,
            "replacement_activations": 0,
            "replacement_shortfalls": 0,
            "return_requests": 0,
            "return_retries": 0,
            "returned_to_disengaged": 0,
            "return_delayed": 0,
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
        self.backup_standby_time = 0.0
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

    def _record_task_outcome(self, result, task, role, health):
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
            outcome = "succeeded"
            self.task_outcome_counts["succeeded"] += 1

        task = task or result.get("task", "unknown")
        role = role or "unknown"
        health = health or result.get("health", "Unknown")
        counts = (
            self.task_outcomes_by_task_role_health
            .setdefault(task, {})
            .setdefault(role, {})
            .setdefault(health, {
                "attempted": 0,
                "succeeded": 0,
                "failed_health": 0,
                "failed_physical": 0,
                "failed_other": 0,
            })
        )
        counts["attempted"] += 1
        counts[outcome] += 1

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
        # Unused reserve boats keep Reactive in Mixed. After activation or
        # return to the reserve role, profile assignment follows that role.
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
        time_minutes = max(0.0, time_available / 60.0)
        area_factor = 1.0 + self.flood.flooded_area * SIMULATION["rescue_area_penalty"]
        return (
            SIMULATION["rescue_capacity_per_boat_minute"]
            * time_minutes
            * success_probability
            / area_factor
        )

    @staticmethod
    def _task_success_probability(twin):
        return TASK_SUCCESS_PROBABILITY_BY_HEALTH.get(twin.health_state(), 0.0)

    def minimum_rescue_boats(self):
        waiting = [v for v in self.flood.mission_targets if v["status"] == "waiting"]
        if not waiting:
            return 0
        deadlines = sorted({mission_target["deadline"] for mission_target in waiting})
        minimum = 0
        for deadline in deadlines:
            due = sum(mission_target["deadline"] <= deadline for mission_target in waiting)
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
                (
                    twin.unit.role == "reserve"
                    and twin.belonging_state() == "Disengaged"
                    and twin.health_state() == "Ideal"
                )
                or (twin.unit.role in {"monitoring", "rescue"} and twin.can_operate)
            )
        ]

    def ensure_rescue_capacity(self):
        required = self.minimum_rescue_boats()
        available_boats = self._available_boats()
        # Use occupied rescue roles, not health-weighted task probabilities,
        # to detect demand-driven vacancies. A Reactive boat that remains
        # Active in poor health still occupies its role and must fail through
        # its task outcomes rather than silently causing health replacement.
        active_rescue_slots = sum(
            1
            for twin in self.twins.values()
            if twin.unit.asset_type == "boat"
            and twin.unit.role == "rescue"
            and twin.is_in_constellation
            and twin.connected
        )
        active_monitoring_slots = sum(
            1
            for twin in self.twins.values()
            if twin.unit.asset_type == "boat"
            and twin.unit.role == "monitoring"
            and twin.is_in_constellation
            and twin.connected
        )
        reserve_slots = sum(twin.unit.role == "reserve" for twin in available_boats)
        target_rescue_slots = min(
            required,
            active_rescue_slots + active_monitoring_slots + reserve_slots,
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
        replacements_remaining = len(self.pending_health_replacements)
        while (
            active_rescue_slots < target_rescue_slots
            or replacements_remaining > 0
        ):
            replacing_health_departure = replacements_remaining > 0
            replacement_request = (
                self.pending_health_replacements[0]
                if replacing_health_departure
                else None
            )
            departed_name = (
                replacement_request["departed_unit"]
                if replacement_request is not None
                else None
            )
            candidates = sorted(
                (
                    twin
                    for twin in available_boats
                    if twin not in attached_rescue
                    and twin.name not in attempted_candidates
                    and (
                        (
                            twin.name != departed_name
                            and twin.unit.role == "reserve"
                            and twin.belonging_state() == "Disengaged"
                            and twin.health_state() == "Ideal"
                            and twin.unit.operational
                            and twin.connected
                        )
                        if replacing_health_departure
                        else (
                            (twin.unit.role == "monitoring" and twin.can_operate)
                            or twin.unit.role == "reserve"
                        )
                    )
                ),
                key=lambda twin: (
                    twin.unit.role != "reserve",
                    -self._task_success_probability(twin),
                    not twin.is_attached_to_sos,
                    twin.name,
                ),
            )
            if not candidates:
                if replacing_health_departure:
                    if departed_name not in self.backup_shortfall_logged:
                        self.backup_shortfall_logged.add(departed_name)
                        self.events.append(
                            {
                                "time": self.env.now,
                                "event": "health_replacement_unavailable",
                                "departed_unit": departed_name,
                                "departed_role": replacement_request["role_at_departure"],
                                "departure_time": replacement_request["departure_time"],
                                "reason": "no_eligible_disengaged_ideal_backup",
                            }
                        )
                        self.health_lifecycle_counts["replacement_shortfalls"] += 1
                        replacement_request["shortfall_recorded"] = True
                break
            twin = candidates[0]
            last_attempt = self.last_join_attempt.get(twin.name, -math.inf)
            if self.env.now - last_attempt < SIMULATION["join_retry_interval"]:
                attempted_candidates.add(twin.name)
                continue
            attempted_candidates.add(twin.name)
            self.last_join_attempt[twin.name] = self.env.now
            reason = "health_departure" if replacing_health_departure else "rescue_capacity"
            if twin.unit.role == "reserve":
                self.backup_requests += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "backup_requested",
                        "unit": twin.name,
                        "reason": reason,
                        "replaced_unit": departed_name,
                        "replaced_role": (
                            replacement_request["role_at_departure"]
                            if replacement_request is not None
                            else None
                        ),
                        "departure_time": (
                            replacement_request["departure_time"]
                            if replacement_request is not None
                            else None
                        ),
                        "effective_rescue_boat_capacity": round(attached_capacity, 4),
                        "required_rescue_boat_capacity": required,
                    }
                )
            self.join_request_counts["generated"] += 1
            join_request = {
                "time": self.env.now,
                "unit": twin.name,
                "profile": twin.profile,
                "reason": reason,
                "replaced_unit": departed_name,
                "replacement_role": (
                    replacement_request["role_at_departure"]
                    if replacement_request is not None
                    else None
                ),
            }
            self.events.append({"event": "sos_join_request", **join_request})
            policy = PROFILE_MEMBERSHIP_POLICY[twin.profile]
            if (
                not replacing_health_departure
                and self.random.random() >= policy["join_acceptance"]
            ):
                self.join_request_counts["profile_denied"] += 1
                self.events.append({"event": "sos_join_denied_by_profile", **join_request})
                continue

            previous_role = twin.unit.role
            replacement_role = "rescue"
            if replacing_health_departure:
                replacement_role = replacement_request["role_at_departure"]
            twin.unit.set_role(replacement_role)
            # Apply the activated role's profile before entering the generated
            # belonging machine so admission uses the intended resilience.
            self.update_profiles_for(twin)
            self.join_request_counts["submitted_to_bm"] += 1
            joined = twin.join_sos(join_constellation=True)
            if not joined:
                twin.unit.set_role(previous_role)
                self.update_profiles_for(twin)
                twin.request_disengaged("backup_activation_rejected")
                self.join_request_counts["machine_rejected"] += 1
                self.events.append({"event": "sos_join_rejected_by_machine", **join_request})
                continue
            self.join_request_counts["completed"] += 1
            self.assignments[twin.name] = replacement_role
            operational_activation = (
                twin.is_in_constellation
                and twin.can_operate
                and twin.connected
                and twin.unit.role == replacement_role
                and self._task_success_probability(twin) > 0.0
            )
            if not operational_activation:
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "health_replacement_activation_unusable"
                        if replacing_health_departure
                        else "backup_activation_unusable",
                        "unit": twin.name,
                        "role": twin.unit.role,
                        "required_role": replacement_role,
                        "belonging": twin.belonging_state(),
                        "health": twin.health_state(),
                        "operational": twin.unit.operational,
                        "connected": twin.connected,
                        "replaced_unit": departed_name,
                    }
                )
                if twin.is_in_constellation:
                    self.backup_unit_names.add(twin.name)
                    self.backup_return_pending.add(twin.name)
                    twin.leave_constellation("replacement_activation_unusable")
                else:
                    twin.unit.set_role(previous_role)
                    self.update_profiles_for(twin)
                    twin.request_disengaged("replacement_activation_unusable")
                continue

            self.events.append(
                {
                    "time": self.env.now,
                    "event": "backup_activated_for_role",
                    "unit": twin.name,
                    "role": replacement_role,
                    "reason": reason,
                    "previous_role": previous_role,
                    "replaced_unit": departed_name,
                    "departure_time": (
                        replacement_request["departure_time"]
                        if replacement_request is not None
                        else None
                    ),
                }
            )
            if replacement_role == "rescue":
                attached_rescue.append(twin)
                attached_capacity += self._task_success_probability(twin)
                active_rescue_slots += 1
            if previous_role == "reserve":
                self.backup_unit_names.add(twin.name)
                self.recovered_standby_roles.pop(twin.name, None)
                self.backup_activations += 1
                if replacing_health_departure:
                    self.pending_health_replacements.remove(replacement_request)
                    replacements_remaining -= 1
                    self.health_lifecycle_counts["replacement_activations"] += 1
                    self.backup_shortfall_logged.discard(departed_name)
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "backup_activated",
                        "unit": twin.name,
                        "role": replacement_role,
                        "reason": reason,
                        "replaced_unit": departed_name,
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
        kept_rescue_slots = 0
        for twin in sorted(
            attached_rescue,
            key=lambda item: (-self._task_success_probability(item), item.name),
        ):
            if kept_rescue_slots < target_rescue_slots:
                kept_rescue_slots += 1
                continue
            original_role = twin.unit.config["role"]
            if twin.name in self.backup_unit_names:
                twin.leave_constellation("backup_surplus")
                self.backup_return_pending.add(twin.name)
            elif original_role == "monitoring":
                twin.unit.set_role(original_role)
                self.assignments[twin.name] = original_role
                self.update_profiles_for(twin)

        self.process_backup_returns()

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
            rate_interval_minutes = step / 60.0
            probability = 1.0 - math.exp(-rate * rate_interval_minutes)
            if self.random.random() >= probability:
                continue

            self.sos_request_counts["generated"] += 1
            self.departure_request_sequence += 1
            policy = PROFILE_MEMBERSHIP_POLICY[twin.profile]
            request = {
                "request_id": self.departure_request_sequence,
                "time": self.env.now,
                "unit": twin.name,
                "profile": twin.profile,
                "rate": rate,
                "rate_unit": "per_minute",
                "reason": "sos_autonomy",
            }
            self.events.append({"event": "sos_departure_request", **request})
            if self.random.random() >= policy["leave_acceptance"]:
                self.sos_request_counts["profile_denied"] += 1
                self.events.append({"event": "sos_departure_denied_by_profile", **request})
                self._record_blocked_departure(twin, request, "profile_denied")
                continue

            required = self.minimum_rescue_boats()
            remaining_boats = self._active_boat_count(excluding=twin)
            if remaining_boats < required:
                self.sos_request_counts["capacity_deferred"] += 1
                self._record_blocked_departure(twin, request, "capacity_deferred")
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "sos_departure_deferred_for_capacity",
                        "request_id": request["request_id"],
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

    def _record_blocked_departure(self, twin, request, blocking_reason):
        """Track a non-overlapping retention episode after a blocked leave request."""
        episode = self.open_departure_retention.get(twin.name)
        if episode is None:
            episode = {
                "unit": twin.name,
                "role": twin.unit.role,
                "profile": request["profile"],
                "start_time": request["time"],
                "initial_block_reason": blocking_reason,
                "blocked_request_count": 0,
                "blocked_request_ids": [],
                "profile_denied_requests": 0,
                "capacity_deferred_requests": 0,
                "completed": False,
            }
            self.departure_retention_episodes.append(episode)
            self.open_departure_retention[twin.name] = episode
        episode["blocked_request_count"] += 1
        episode["blocked_request_ids"].append(request["request_id"])
        if blocking_reason == "profile_denied":
            episode["profile_denied_requests"] += 1
        elif blocking_reason == "capacity_deferred":
            episode["capacity_deferred_requests"] += 1
        self.events.append(
            {
                "time": request["time"],
                "event": "departure_retention_blocked",
                "request_id": request["request_id"],
                "unit": twin.name,
                "blocking_reason": blocking_reason,
                "retention_episode_start": episode["start_time"],
            }
        )

    def _close_departure_retention(self, unit, time, end_reason):
        episode = self.open_departure_retention.pop(unit, None)
        if episode is None:
            return
        episode["end_time"] = time
        episode["duration_seconds"] = max(0.0, time - episode["start_time"])
        episode["end_reason"] = end_reason
        episode["completed"] = True
        self.events.append(
            {
                "time": time,
                "event": "departure_retention_ended",
                "unit": unit,
                "duration_seconds": episode["duration_seconds"],
                "end_reason": end_reason,
                "initial_block_reason": episode["initial_block_reason"],
                "blocked_request_ids": list(episode["blocked_request_ids"]),
            }
        )

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
                    announced = bool(entry.get("announced", False))
                    belonging_changed = before.get("belonging") != after.get("belonging")
                    if announced and belonging_changed:
                        self.events.append(
                            {
                                "time": entry.get("time", self.env.now),
                                "event": "sos_membership_notification",
                                "unit": name,
                                "from_belonging": before.get("belonging"),
                                "to_belonging": after.get("belonging"),
                                "health": after.get("health"),
                                "cause": cause,
                            }
                        )
                    # Some generated health responses defer the actual
                    # membership departure (Adaptive PendingExit). Preserve
                    # that generated cause until its announced Active exit.
                    health_event = (
                        cause.startswith(("health:", "environmental_fault:"))
                        and before.get("health") != after.get("health")
                    )
                    pending_health_exit = self.pending_health_exits.get(name)
                    left_active_membership = (
                        before.get("belonging") == "Active"
                        and after.get("belonging") != "Active"
                    )
                    if left_active_membership:
                        self._close_departure_retention(
                            name,
                            entry.get("time", self.env.now),
                            "left_active_membership",
                        )
                    if left_active_membership and announced:
                        if health_event or pending_health_exit is not None:
                            self.pending_health_exits.pop(name, None)
                            health = after.get("health", "Unknown")
                            if name not in self.health_return_eligible:
                                self.health_lifecycle_counts["eligible_departures"] += 1
                            self.health_return_eligible.add(name)
                            if twin.unit.asset_type == "boat" and twin.unit.role in {"rescue", "monitoring"}:
                                if not any(
                                    request["departed_unit"] == name
                                    for request in self.pending_health_replacements
                                ):
                                    replacement_request = {
                                        "departed_unit": name,
                                        "role_at_departure": twin.unit.role,
                                        "departure_time": entry.get("time", self.env.now),
                                        "health_at_departure": health,
                                        "shortfall_recorded": False,
                                    }
                                    self.pending_health_replacements.append(replacement_request)
                                    self.health_lifecycle_counts["replacement_requests"] += 1
                                    self.events.append(
                                        {
                                            "time": entry.get("time", self.env.now),
                                            "event": "health_replacement_requested",
                                            **replacement_request,
                                        }
                                    )
                            else:
                                self.events.append(
                                    {
                                        "time": entry.get("time", self.env.now),
                                        "event": "health_replacement_unavailable",
                                        "departed_unit": name,
                                        "reason": "no_matching_reserve_pool",
                                        "asset_type": twin.unit.asset_type,
                                        "role": twin.unit.role,
                                    }
                                )
                            self.events.append(
                                {
                                    "time": entry.get("time", self.env.now),
                                    "event": "health_related_departure",
                                    "unit": name,
                                    "health": health,
                                    "profile": twin.profile,
                                    "role_at_departure": twin.unit.role,
                                    "from_belonging": before.get("belonging"),
                                    "to_belonging": after.get("belonging"),
                                }
                            )
                elif entry.get("event") == "health_exit_pending":
                    self.pending_health_exits[name] = {
                        "time": entry.get("time", self.env.now),
                        "health": entry.get("health", twin.health_state()),
                        "profile": entry.get("profile", twin.profile),
                        "cause": entry.get("cause", ""),
                    }
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "health_exit_cancelled":
                    pending = self.pending_health_exits.pop(name, None)
                    self.events.append(
                        {
                            "unit": name,
                            **entry,
                            "pending_exit_was_tracked": pending is not None,
                        }
                    )
                elif entry.get("event") == "task_attempt_result":
                    self._record_task_outcome(
                        entry.get("result") or {},
                        entry.get("task"),
                        entry.get("role"),
                        entry.get("health"),
                    )
                    self.events.append(
                        {
                            "time": entry.get("time", self.env.now),
                            "event": "task_attempt_result",
                            "unit": name,
                            "task": entry.get("task"),
                            "role": entry.get("role"),
                            "health": entry.get("health"),
                            "profile": entry.get("profile"),
                            "result": entry.get("result"),
                        }
                    )
                elif entry.get("event") == "health_communication_changed":
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "repair_preparation_requested":
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "repair_requested":
                    self.events.append({"unit": name, **entry})
                elif entry.get("event") == "repair_completed" and name in self.health_return_eligible:
                    if name not in self.health_return_ready:
                        self.health_lifecycle_counts["repairs_ready"] += 1
                    self.health_return_ready.add(name)
                    unresolved = [
                        request
                        for request in self.pending_health_replacements
                        if request["departed_unit"] == name
                    ]
                    for request in unresolved:
                        self.pending_health_replacements.remove(request)
                        if not request["shortfall_recorded"]:
                            self.health_lifecycle_counts["replacement_shortfalls"] += 1
                        self.events.append(
                            {
                                "time": entry.get("time", self.env.now),
                                "event": "health_replacement_shortfall_repair_completed",
                                "departed_unit": name,
                                "departed_role": request["role_at_departure"],
                                "departure_time": request["departure_time"],
                                "repair_completed_at": entry.get("time", self.env.now),
                                "unreplaced_duration": max(
                                    0.0,
                                    entry.get("time", self.env.now) - request["departure_time"],
                                ),
                            }
                        )
                        self.backup_shortfall_logged.discard(name)
            if name in self.pending_departures and not twin.is_in_constellation:
                # Some generated machines complete their exit in a later timer cycle.
                self.pending_departures.remove(name)
                self.sos_request_counts["completed"] += 1
                if name in self.backup_unit_names:
                    self.backup_return_pending.add(name)
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "sos_departure_completed",
                        "unit": name,
                        "profile": twin.profile,
                        "belonging": twin.belonging_state(),
                    }
                )

    def process_backup_returns(self):
        """Move a no-longer-needed or repaired unit to generated Disengaged backup status."""
        names = self.backup_return_pending | self.health_return_ready
        for name in list(names):
            twin = self.twins[name]
            if name in self.health_return_ready and (
                twin.health_state() != "Ideal" or not twin.unit.operational
            ):
                continue
            if twin.is_in_constellation:
                continue

            last_attempt = self.last_health_return_attempt.get(name, -math.inf)
            retry_interval = SIMULATION["health_return_retry_interval"]
            if self.env.now - last_attempt < retry_interval:
                continue
            self.last_health_return_attempt[name] = self.env.now
            self.health_lifecycle_counts["return_requests"] += 1
            if twin.belonging_state() == "Disengaged":
                disengaged = True
            else:
                disengaged = twin.request_disengaged("health_repair_return")
            if disengaged:
                prior_role = twin.unit.config.get("role", twin.unit.role)
                twin.unit.set_role("reserve")
                if twin.unit.asset_type == "boat":
                    self.backup_unit_names.add(name)
                self.recovered_standby_roles[name] = prior_role
                self.update_profiles_for(twin)
                self.backup_return_pending.discard(name)
                self.health_return_ready.discard(name)
                self.health_return_eligible.discard(name)
                self.health_lifecycle_counts["returned_to_disengaged"] += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "health_repaired_unit_returned_to_backup",
                        "unit": name,
                        "profile": twin.profile,
                        "health": twin.health_state(),
                        "belonging": twin.belonging_state(),
                    }
                )
            else:
                self.health_lifecycle_counts["return_retries"] += 1
                self.health_lifecycle_counts["return_delayed"] += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "health_repaired_unit_return_delayed",
                        "unit": name,
                        "health": twin.health_state(),
                        "belonging": twin.belonging_state(),
                    }
                )

    def _recovered_unit_is_needed(self, twin, prior_role):
        if twin.unit.asset_type == "drone":
            return not any(
                other is not twin
                and other.unit.asset_type == "drone"
                and other.can_operate
                and other.connected
                for other in self.twins.values()
            )
        if twin.unit.asset_type == "pump":
            return self.flood.water_level > SIMULATION["initial_water_level"]
        if twin.unit.asset_type == "boat" and prior_role == "monitoring":
            return not any(
                other is not twin
                and other.unit.asset_type == "boat"
                and other.unit.role == "monitoring"
                and other.can_operate
                and other.connected
                for other in self.twins.values()
            )
        # Recovered rescue boats are activated by ensure_rescue_capacity when
        # their expected capacity is needed.
        return False

    def activate_recovered_units_if_needed(self):
        """Reactivate repaired non-rescue DTs only when their service is needed."""
        for name, prior_role in list(self.recovered_standby_roles.items()):
            twin = self.twins[name]
            if (
                twin.belonging_state() != "Disengaged"
                or twin.health_state() != "Ideal"
                or not twin.unit.operational
                or not self._recovered_unit_is_needed(twin, prior_role)
            ):
                continue
            last_attempt = self.last_standby_activation_attempt.get(name, -math.inf)
            if self.env.now - last_attempt < SIMULATION["health_return_retry_interval"]:
                continue
            self.last_standby_activation_attempt[name] = self.env.now
            original_current_role = twin.unit.role
            if twin.unit.asset_type == "boat" and prior_role == "monitoring":
                twin.unit.set_role("monitoring")
                self.update_profiles_for(twin)
            self.join_request_counts["generated"] += 1
            self.events.append(
                {
                    "time": self.env.now,
                    "event": "recovered_dt_activation_requested",
                    "unit": name,
                    "role": prior_role,
                    "reason": "service_needed",
                }
            )
            self.join_request_counts["submitted_to_bm"] += 1
            if twin.join_sos(join_constellation=True):
                self.join_request_counts["completed"] += 1
                self.recovered_standby_roles.pop(name, None)
                self.backup_unit_names.discard(name)
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "recovered_dt_activated_for_service",
                        "unit": name,
                        "role": twin.unit.role,
                    }
                )
            else:
                twin.unit.set_role(original_current_role)
                twin.request_disengaged("standby_activation_rejected")
                self.join_request_counts["machine_rejected"] += 1
                self.events.append(
                    {
                        "time": self.env.now,
                        "event": "recovered_dt_activation_rejected",
                        "unit": name,
                        "role": prior_role,
                    }
                )

    def dispatch_tasks(self):
        for twin in self.twins.values():
            twin.last_task_succeeded = False
            # Active but degraded/faulty DTs still receive their assigned task:
            # the physical twin reports the failed outcome, preserving the
            # mission impact rather than silently omitting the DT.
            if (
                not twin.is_in_constellation
                or not twin.connected
                or twin.role_restricted
                or twin.health_exit_pending
            ):
                continue
            asset_type = twin.unit.asset_type
            role = twin.unit.role
            if asset_type == "drone":
                twin.receive_command({"action": "monitor"})
            elif asset_type == "pump":
                interval_minutes = SIMULATION["step"] / 60.0
                twin.receive_command(
                    {
                        "action": "pump",
                        "amount_m3": SIMULATION["pump_discharge_m3_per_minute"] * interval_minutes,
                    }
                )
            elif asset_type == "boat" and role == "rescue":
                twin.receive_command(
                    {
                        "action": "rescue",
                        "capacity": (
                            SIMULATION["rescue_capacity_per_boat_minute"]
                            * SIMULATION["step"]
                            / 60.0
                        ),
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
                twin.name in self.backup_unit_names
                and twin.unit.role == "rescue"
                and twin.is_in_constellation
            ):
                self.backup_rescue_time += SIMULATION["step"]
            if (
                twin.name in self.backup_unit_names
                and twin.unit.role == "reserve"
                and twin.belonging_state() == "Disengaged"
                and twin.health_state() == "Ideal"
                and twin.unit.operational
                and twin.connected
            ):
                self.backup_standby_time += SIMULATION["step"]

    def _record_processing_work(self):
        for twin in self.twins.values():
            if twin.connected and twin.is_attached_to_sos:
                multiplier = PROFILE_MEMBERSHIP_POLICY[twin.profile]["processing_work_per_minute"]
                self.processing_work += multiplier * SIMULATION["step"] / 60.0

    def run(self):
        while self.env.now < SIMULATION["duration"]:
            # Consume generated-machine announcements before making capacity,
            # repair, or replacement decisions for this simulation step.
            self.observe_state_changes()
            self.update_profiles()
            self.ensure_rescue_capacity()
            self.process_voluntary_departures()
            self.dispatch_tasks()
            self.observe_state_changes()
            self.process_backup_returns()
            self.activate_recovered_units_if_needed()
            self.observe_state_changes()
            self._record_processing_work()
            self._record_resource_time()
            self.assignments = {t.name: t.unit.role for t in self.twins.values()}
            yield self.env.timeout(SIMULATION["step"])

    def metrics(self):
        horizon = min(float(self.env.now), float(SIMULATION["duration"]))
        retention_durations = [
            episode.get("duration_seconds", max(0.0, horizon - episode["start_time"]))
            for episode in self.departure_retention_episodes
        ]
        retention_seconds = sum(retention_durations)
        retention_episodes = len(self.departure_retention_episodes)
        return {
            "peak_attached_dts": self.peak_attached_dts,
            "peak_constellation_dts": self.peak_constellation_dts,
            "dt_time": self.dt_time / 60.0,
            "dt_time_by_asset": {key: value / 60.0 for key, value in self.dt_time_by_asset.items()},
            "active_dt_time": self.active_dt_time / 60.0,
            "active_dt_time_by_asset": {
                key: value / 60.0 for key, value in self.active_dt_time_by_asset.items()
            },
            "pumping_station_active_time": self.pumping_station_active_time / 60.0,
            "pumping_station_service_time": self.pumping_station_service_time / 60.0,
            "pumping_station_health_communication_unavailable_time": (
                self.pumping_station_health_communication_unavailable_time / 60.0
            ),
            "backup_activations": self.backup_activations,
            "backup_requests": self.backup_requests,
            "backup_rescue_time": self.backup_rescue_time / 60.0,
            "backup_standby_time": self.backup_standby_time / 60.0,
            "processing_work": self.processing_work,
            "sos_request_counts": dict(self.sos_request_counts),
            "forced_retention_minutes": retention_seconds / 60.0,
            "mean_forced_retention_episode_minutes": (
                retention_seconds / 60.0 / retention_episodes if retention_episodes else 0.0
            ),
            "forced_retention_episodes": retention_episodes,
            "forced_retention_episodes_profile_denied": sum(
                episode["initial_block_reason"] == "profile_denied"
                for episode in self.departure_retention_episodes
            ),
            "forced_retention_episodes_capacity_deferred": sum(
                episode["initial_block_reason"] == "capacity_deferred"
                for episode in self.departure_retention_episodes
            ),
            "forced_retention_completed_episodes": sum(
                episode["completed"] for episode in self.departure_retention_episodes
            ),
            "forced_retention_censored_episodes": len(self.open_departure_retention),
            "forced_retention_minutes_profile_denied": sum(
                duration
                for episode, duration in zip(self.departure_retention_episodes, retention_durations)
                if episode["initial_block_reason"] == "profile_denied"
            ) / 60.0,
            "forced_retention_minutes_capacity_deferred": sum(
                duration
                for episode, duration in zip(self.departure_retention_episodes, retention_durations)
                if episode["initial_block_reason"] == "capacity_deferred"
            ) / 60.0,
            "departure_retention_episodes_detail": [
                {
                    **episode,
                    "duration_minutes": duration / 60.0,
                    "censored_at_mission_end": not episode["completed"],
                }
                for episode, duration in zip(self.departure_retention_episodes, retention_durations)
            ],
            "join_request_counts": dict(self.join_request_counts),
            "health_lifecycle_counts": dict(self.health_lifecycle_counts),
            "task_outcome_counts": dict(self.task_outcome_counts),
            "task_outcomes_by_task_role_health": self.task_outcomes_by_task_role_health,
            "repair_time": sum(twin.repair_time for twin in self.twins.values()) / 60.0,
            "repair_requests": sum(twin.repair_requests for twin in self.twins.values()),
            "repairs_completed": sum(twin.repairs_completed for twin in self.twins.values()),
        }
