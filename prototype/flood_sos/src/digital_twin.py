from importlib import import_module
from inspect import isclass
import random

from config import PROFILE_LEVELS, SIMULATION, TASK_SUCCESS_PROBABILITY_BY_HEALTH
from timer_service import TimerService


PROFILE_MODULES = {
    "Reactive": "reactive",
    "Proactive": "proactive",
    "Controlled": "controlled",
    "Adaptive": "adaptive",
}

HEALTH_EVENT_SEQUENCE = [
    ("Defective", "component_deviation"),
    ("Faulty", "defect_activated"),
    ("Erroneous", "fault_exercised"),
    ("Malfunctioning", "error_propagated"),
    ("Degraded", "impact_observed"),
    ("Failed", "threshold_violated"),
]


def create_machine(profile):
    module = import_module("generated." + PROFILE_MODULES[profile])
    preferred = [profile, profile + "StateMachine", profile + "Machine"]
    for name in preferred:
        candidate = getattr(module, name, None)
        if isclass(candidate):
            return candidate()
    for candidate in vars(module).values():
        if not isclass(candidate) or candidate.__module__ != module.__name__:
            continue
        try:
            instance = candidate()
        except Exception:
            continue
        if all(hasattr(instance, attr) for attr in ("enter", "is_state_active", "State", "bm", "hm")):
            return instance
    raise ImportError(f"Could not identify the generated state-machine class in generated.{PROFILE_MODULES[profile]}")


class DigitalTwin:
    BELONGING_STATES = {
        "Disengaged": ("belonging_disengaged",),
        "Prepared": ("belonging_prepared",),
        "Passive": ("belonging_passive",),
        "Active": ("belonging_active",),
    }

    def __init__(self, name, unit, broker, machine, profile, joined_at_start=True, seed=0):
        self.name = name
        self.unit = unit
        self.broker = broker
        self.machine = machine
        self.profile = profile
        self.timer_service = TimerService(broker.env)
        self.connected = True
        self.last_telemetry = {}
        self.task = None
        self.last_task_succeeded = False
        # Stable per-twin RNG streams make probabilistic task degradation
        # reproducible and independent of Poisson membership decisions.
        stable_name_seed = sum((index + 1) * ord(char) for index, char in enumerate(name))
        self.task_random = random.Random(seed + stable_name_seed)
        self.log = []
        self.repair_started_at = None
        self.repair_last_accounted_at = None
        self.repair_time = 0.0
        self.repairs_completed = 0
        self.repair_requests = 0
        self.repair_request_pending = False
        self.last_join_result = False
        self._unmatched_belonging_announcements = 0
        self._health_exit_pending = False
        self._configure_machine(self.machine)
        self.machine.enter()
        if joined_at_start:
            self.join_sos(join_constellation=bool(unit.config.get("active_at_start", True)))
        self._observed_state = self._state_snapshot()
        self._observed_health_communication = self.health_communication_available

    def _time(self):
        return self.broker.env.now

    def _configure_machine(self, machine):
        machine.bm.operation_callback = self
        if hasattr(machine, "timer_service"):
            machine.timer_service = self.timer_service

    def _state_snapshot(self):
        return {"health": self.health_state(), "belonging": self.belonging_state()}

    def _adaptive_exit_is_pending(self):
        """Return whether Adaptive's generated belonging region is deferring exit."""
        if self.profile != "Adaptive":
            return False
        return self.state_active("belonging_active_active_region_pending_exit")

    def _track_adaptive_health_exit(self, cause, before, after, announced):
        pending_now = self._adaptive_exit_is_pending()
        health_trigger = cause.startswith(("health:", "environmental_fault:"))

        if (
            not self._health_exit_pending
            and pending_now
            and health_trigger
            and before.get("belonging") == "Active"
            and after.get("belonging") == "Active"
            and announced
        ):
            self._health_exit_pending = True
            self.log.append(
                {
                    "time": self._time(),
                    "event": "health_exit_pending",
                    "unit": self.name,
                    "profile": self.profile,
                    "health": after.get("health"),
                    "belonging": after.get("belonging"),
                    "cause": cause,
                }
            )
        elif self._health_exit_pending and not pending_now:
            self._health_exit_pending = False
            # PendingExit -> Participating means the generated machine
            # cancelled the deferred exit. A completed Active departure is
            # consumed by the coordinator instead.
            if before.get("belonging") == "Active" and after.get("belonging") == "Active":
                self.log.append(
                    {
                        "time": self._time(),
                        "event": "health_exit_cancelled",
                        "unit": self.name,
                        "profile": self.profile,
                        "health": after.get("health"),
                        "belonging": after.get("belonging"),
                        "cause": cause,
                    }
                )

    def _record_transition(self, cause, before, announced=None):
        after = self._state_snapshot()
        if after != before:
            if announced is None:
                announced = self._unmatched_belonging_announcements > 0
                if announced:
                    self._unmatched_belonging_announcements -= 1
            self.log.append(
                {
                    "time": self._time(),
                    "event": "state_transition",
                    "cause": cause,
                    "from": before,
                    "to": after,
                    "announced": announced,
                }
            )
        self._observed_state = after
        self._track_adaptive_health_exit(cause, before, after, bool(announced))

    @property
    def health_communication_available(self):
        """Health-induced comms availability, independent of network outages."""
        return not (
            self.unit.asset_type == "pump"
            and self.health_state() in {"Degraded", "Failed"}
        )

    def _record_health_communication_change(self):
        available = self.health_communication_available
        previous = getattr(self, "_observed_health_communication", available)
        if available != previous:
            self.log.append(
                {
                    "time": self._time(),
                    "event": "health_communication_changed",
                    "available": available,
                    "health": self.health_state(),
                }
            )
        self._observed_health_communication = available

    def sync_state_changes(self, cause="generated"):
        before = getattr(self, "_observed_state", self._state_snapshot())
        self._record_transition(cause, before)
        self._record_health_communication_change()

    def _raise_first_available(self, region, candidates, cause=None):
        for event_name in candidates:
            method = getattr(region, event_name, None)
            if callable(method):
                before = self._state_snapshot() if hasattr(self, "machine") else {}
                announcements_before = self._unmatched_belonging_announcements
                method()
                announced = self._unmatched_belonging_announcements > announcements_before
                # Associate callbacks raised synchronously by this generated
                # event with this state snapshot; do not let them mark a later
                # unrelated state change as an announcement.
                self._unmatched_belonging_announcements = announcements_before
                if cause:
                    self._record_transition(cause, before, announced=announced)
                return True
        return False

    def state_active(self, state_name):
        state = getattr(self.machine.State, state_name, None)
        return bool(state is not None and self.machine.is_state_active(state))

    def health_state(self):
        for state in ("Ideal", "Defective", "Faulty", "Erroneous", "Malfunctioning", "Degraded", "Failed"):
            if self.state_active("health_" + state.lower()):
                return state
        return "Unknown"

    def belonging_state(self):
        for state, enum_names in self.BELONGING_STATES.items():
            if any(self.state_active(enum_name) for enum_name in enum_names):
                return state
        return "Unknown"

    @property
    def is_attached_to_sos(self):
        return self.belonging_state() in {"Passive", "Active"}

    @property
    def is_in_constellation(self):
        return self.belonging_state() == "Active"

    @property
    def role_restricted(self):
        return any(
            self.state_active(name)
            for name in (
                "belonging_active_active_region_participating_region0restricted_role",
                "belonging_active_active_region_participating__region0_restricted_role",
                "belonging_active_active_region_restricted_role",
            )
        )

    @property
    def health_exit_pending(self):
        return self._health_exit_pending

    @property
    def can_operate(self):
        return (
            self.unit.operational
            and self.is_in_constellation
            and not self.role_restricted
            and not self.health_exit_pending
        )

    def _request_adaptive_health_exit(self):
        """Resolve Adaptive's generated RestrictedRole state through its BM API."""
        if self.profile != "Adaptive" or not self.is_in_constellation or not self.role_restricted:
            return False
        return self._raise_first_available(
            self.machine.bm,
            ["raise_uncertainty_exceeded"],
            "health:adaptive_role_restricted",
        )

    def _join_constellation_events(self):
        if self.belonging_state() == "Disengaged":
            self._raise_first_available(self.machine.bm, ["raise_prepare_for_sos"], "prepare_for_sos")
        if self.belonging_state() == "Prepared":
            self._raise_first_available(self.machine.bm, ["raise_join_so_s"], "join_sos")
        if self.belonging_state() != "Passive":
            return

        # Controlled and Adaptive use an admission sub-state. Their generated
        # machine decides which request/invitation is valid for its health state.
        if self.health_state() == "Ideal":
            self._raise_first_available(self.machine.bm, ["raise_join_request"], "join_request")
        else:
            self._raise_first_available(self.machine.bm, ["raise_join_invitation"], "join_invitation")
        self._raise_first_available(self.machine.bm, ["raise_join_constellation"], "join_constellation")

    def join_sos(self, join_constellation=True):
        if self.belonging_state() == "Disengaged":
            self._raise_first_available(self.machine.bm, ["raise_prepare_for_sos"], "prepare_for_sos")
        if self.belonging_state() == "Prepared":
            self._raise_first_available(self.machine.bm, ["raise_join_so_s"], "join_sos")
        if join_constellation:
            self._join_constellation_events()
        self.last_join_result = self.is_in_constellation
        self.log.append({"time": self._time(), "event": "joined", "constellation": self.last_join_result})
        return self.last_join_result

    def request_disengaged(self, reason="return_to_backup"):
        """Request a generated belonging path back to Disengaged.

        Active membership is left to health-driven generated transitions. Once
        the twin is no longer Active, these requests only advance the generated
        belonging machine one step at a time: Passive -> Prepared -> Disengaged.
        """
        state = self.belonging_state()
        if state == "Passive":
            self._raise_first_available(
                self.machine.bm, ["raise_leave_so_s"], reason + ":leave_sos"
            )
        elif state == "Prepared":
            self._raise_first_available(
                self.machine.bm, ["raise_disengage_from_so_s"], reason + ":disengage"
            )
        elif state == "Active":
            return False
        return self.belonging_state() == "Disengaged"

    def leave_constellation(self, reason):
        if not self.is_in_constellation:
            return False
        raised = self._raise_first_available(
            self.machine.bm, ["raise_leave_constellation"], reason
        )
        self.log.append({"time": self._time(), "event": "departure_requested", "reason": reason, "accepted": raised})
        return raised

    def set_profile(self, profile):
        if profile not in PROFILE_LEVELS or profile == self.profile:
            return False

        old_profile = self.profile
        previous_health = self.health_state()
        previous_belonging = self.belonging_state()
        previous_state = {"health": previous_health, "belonging": previous_belonging}
        self.machine.exit()
        self.machine = create_machine(profile)
        self._configure_machine(self.machine)
        self.machine.enter()
        self.profile = profile
        self._observed_state = self._state_snapshot()
        self._replay_health(previous_health)
        if previous_belonging in {"Passive", "Active"}:
            self.join_sos(join_constellation=previous_belonging == "Active")
        elif previous_belonging == "Prepared":
            self._raise_first_available(self.machine.bm, ["raise_prepare_for_sos"], "restore_prepared")
        restored_state = self._state_snapshot()
        if restored_state != previous_state:
            self.log.append(
                {
                    "time": self._time(),
                    "event": "state_transition",
                    "cause": f"profile_reconfiguration:{old_profile}->{profile}",
                    "from": previous_state,
                    "to": restored_state,
                    "announced": False,
                }
            )
        self._observed_state = restored_state
        self.log.append({"time": self._time(), "event": "profile_changed", "from": old_profile, "to": profile})
        return True

    def _replay_health(self, target_health):
        if target_health == "Ideal":
            return
        for state, event in HEALTH_EVENT_SEQUENCE:
            if self.health_state() == state:
                break
            self._raise_first_available(self.machine.hm, ["raise_" + event], "restore_health:" + state)
            if self.health_state() == target_health:
                break

    def advance_health_to(self, target):
        states = ["Ideal"] + [state for state, _ in HEALTH_EVENT_SEQUENCE]
        if target not in states:
            return
        target_index = states.index(target)
        for state, event in HEALTH_EVENT_SEQUENCE:
            current = self.health_state()
            if current == target or current not in states or states.index(current) >= target_index:
                break
            self._raise_first_available(self.machine.hm, ["raise_" + event], "health:" + state)

    def advance_health_one_step(self):
        """Inject one environmental fault through the generated health API."""
        current = self.health_state()
        states = ["Ideal"] + [state for state, _ in HEALTH_EVENT_SEQUENCE]
        if current not in states or current == "Failed":
            return False
        next_state = states[states.index(current) + 1]
        event = dict(HEALTH_EVENT_SEQUENCE)[next_state]
        raised = self._raise_first_available(
            self.machine.hm, ["raise_" + event], "environmental_fault:" + next_state
        )
        if self.health_state() == "Failed":
            self.unit.operational = False
        return raised

    def _update_repair(self, now):
        if self.health_state() == "Ideal":
            self.repair_started_at = None
            self.repair_last_accounted_at = None
            self.repair_request_pending = False
            return
        # Reactive is the announcement-only profile: health events change HM,
        # but do not initiate repair or cause a belonging transition.
        if self.profile == "Reactive":
            self.repair_started_at = None
            self.repair_last_accounted_at = None
            return
        if self.unit.asset_type == "pump" and self.belonging_state() == "Passive":
            requested = self._raise_first_available(
                self.machine.bm, ["raise_leave_so_s"], "repair_preparation"
            )
            accepted = self.belonging_state() == "Prepared"
            self.log.append(
                {
                    "time": now,
                    "event": "repair_preparation_requested",
                    "event_raised": requested,
                    "accepted": accepted,
                    "belonging": self.belonging_state(),
                }
            )

        repair_ready = (
            self.belonging_state() == "Prepared"
            if self.unit.asset_type == "pump"
            else not self.is_in_constellation
        )
        if not repair_ready:
            self.repair_started_at = None
            self.repair_last_accounted_at = None
            return
        if self.repair_started_at is None:
            if not self.repair_request_pending:
                self.repair_requests += 1
                self.repair_request_pending = True
                self.log.append(
                    {
                        "time": now,
                        "event": "repair_requested",
                        "health": self.health_state(),
                        "belonging": self.belonging_state(),
                    }
                )
            self.repair_started_at = now
            self.repair_last_accounted_at = now
            self.log.append({"time": now, "event": "repair_started"})
            return
        self.repair_time += max(0.0, now - self.repair_last_accounted_at)
        self.repair_last_accounted_at = now
        if now - self.repair_started_at < SIMULATION["repair_duration"]:
            return

        self.unit.repair()
        raised = self._raise_first_available(self.machine.hm, ["raise_recovery"], "repair:recovery")
        self.repairs_completed += 1
        self.log.append({"time": now, "event": "repair_completed", "recovery_event_raised": raised})
        self.repair_started_at = None
        self.repair_last_accounted_at = None

    def update_physical_state(self, now):
        reading = self.unit.update(now)
        transition_count = self.unit.record_flood_exposure(
            self.unit.environment.water_level,
            now,
            exposed=self.is_in_constellation and self.unit.role != "reserve",
        )
        for _ in range(transition_count):
            if not self.advance_health_one_step() or self.health_state() == "Failed":
                break
        if not self.unit.operational and self.health_state() != "Failed":
            self.advance_health_to("Failed")
        # Adaptive's generated chart explicitly waits for uncertainty_exceeded
        # in RestrictedRole before beginning its announced deferred exit.
        # Raise that generated BM event once the chart reports the restricted
        # state; do not assign belonging state in the simulator.
        self._request_adaptive_health_exit()
        self._update_repair(now)
        self.sync_state_changes()
        return reading

    def publish_telemetry(self, reading, now):
        payload = {
            "time": now,
            "unit": self.name,
            "role": self.unit.role,
            "reading": reading,
            "health": self.health_state(),
            "profile": self.profile,
            "connected": self.connected,
            "operational": self.unit.operational,
        }
        self.last_telemetry = payload
        if self.connected and self.health_communication_available:
            self.broker.publish("telemetry", payload, self.name)

    def receive_command(self, command):
        action = command.get("action")
        if action == "task":
            self.task = command.get("task")
        elif action == "withdraw":
            return self.leave_constellation(command.get("reason", "sos"))
        elif action in {"rescue", "pump", "monitor"}:
            health = self.health_state()
            success_probability = TASK_SUCCESS_PROBABILITY_BY_HEALTH.get(health, 0.0)
            failure_probability = 1.0 - success_probability
            if not self.unit.operational:
                result = {
                    "executed": False,
                    "failure_reason": "physical_unavailable",
                    "health": health,
                    "success_probability": success_probability,
                    "task": action,
                }
            elif success_probability <= 0.0 or (
                success_probability < 1.0
                and self.task_random.random() >= success_probability
            ):
                result = {
                    "executed": False,
                    "failure_reason": "health_state_probability",
                    "failure_probability": failure_probability,
                    "success_probability": success_probability,
                    "health": health,
                    "task": action,
                }
            else:
                result = {
                    "executed": True,
                    "success_probability": success_probability,
                    **self.unit.execute(command),
                }
            self.last_task_succeeded = result.get("executed") is not False
            # Keep the execution outcome locally as well as publishing it.
            # The broker can drop messages, but run metrics must still account
            # for every task attempt made by an Active DT.
            self.log.append(
                {
                    "time": self._time(),
                    "event": "task_attempt_result",
                    "task": action,
                    "role": self.unit.role,
                    "profile": self.profile,
                    "health": health,
                    "result": result,
                }
            )
            if self.connected and self.health_communication_available:
                self.broker.publish(
                    "task_result",
                    {"unit": self.name, "action": action, "result": result, "time": self._time()},
                    self.name,
                )
            return result
        return None

    def disconnect(self):
        self.connected = False
        self.log.append({"event": "disconnected", "time": self._time()})

    def reconnect(self):
        self.connected = True
        self.log.append({"event": "reconnected", "time": self._time()})
        self.publish_telemetry(self.last_telemetry.get("reading", {}), self._time())

    def announce(self):
        # Generated machines invoke this callback to notify the SoS of a
        # belonging transition. The machine's API wrapper records the resulting
        # state snapshot after the generated reaction cycle completes.
        self._unmatched_belonging_announcements += 1
        self.log.append({"time": self._time(), "event": "state_machine_announce"})
