from importlib import import_module
from inspect import isclass
from config import PROFILE_LEVELS, SIMULATION
from timer_service import TimerService

PROFILE_MODULES = {"Reactive": "reactive", "Proactive": "proactive", "Controlled": "controlled", "Adaptive": "adaptive"}

def create_machine(profile):
    module = import_module("generated." + PROFILE_MODULES[profile])
    preferred = [profile, profile + "StateMachine", profile + "Machine"]
    for name in preferred:
        candidate = getattr(module, name, None)
        if isclass(candidate):
            return candidate()
    candidates = [value for value in vars(module).values() if isclass(value) and value.__module__ == module.__name__]
    for candidate in candidates:
        try:
            instance = candidate()
        except Exception:
            continue
        if all(hasattr(instance, attr) for attr in ("enter", "is_state_active", "State", "bm", "hm")):
            return instance
    raise ImportError(f"Could not identify the generated state-machine class in generated.{PROFILE_MODULES[profile]}")

class DigitalTwin:
    HEALTH_STATES = [("health_ideal", None), ("health_defective", "component_deviation"), ("health_faulty", "defect_activated"), ("health_erroneous", "fault_exercised"), ("health_malfunctioning", "error_propagated"), ("health_degraded", "impact_observed"), ("health_failed", "threshold_violated")]
    BELONGING_STATES = ["belonging_desingaged", "belonging_prepared", "belonging_passive", "belonging_active"]
    def __init__(self, name, unit, broker, machine, profile):
        self.name = name
        self.unit = unit
        self.broker = broker
        self.machine = machine
        self.profile = profile
        self.timer_service = TimerService(broker.env)
        self.connected = True
        self.last_telemetry = {}
        self.last_seen = 0.0
        self.task = None
        self.role_restricted = False
        self.log = []
        self._configure_machine(self.machine)
        self.machine.enter()
        self._prepare_and_join()
    def _prepare_and_join(self):
        self._raise_first_available(self.machine.bm, ["raise_prepare_for_sos"])
        self._raise_first_available(self.machine.bm, ["raise_join_so_s", "raise_join_sos"])
        self._raise_first_available(self.machine.bm, ["raise_join_constellation"])
    def _raise_first_available(self, region, candidates):
        for name in candidates:
            method = getattr(region, name, None)
            if method is not None:
                method()
                return True
        return False
    def state_active(self, state_name):
        state = getattr(self.machine.State, state_name, None)
        return bool(state is not None and self.machine.is_state_active(state))
    def health_state(self):
        for state, _ in self.HEALTH_STATES:
            if self.state_active(state):
                return state.replace("health_", "").capitalize()
        return "Unknown"
    def belonging_state(self):
        for state in self.BELONGING_STATES:
            if self.state_active(state):
                return state.replace("belonging_", "").capitalize()
        return "Unknown"
    def set_profile(self, profile):
        if PROFILE_LEVELS[profile] > PROFILE_LEVELS[self.profile]:
            old = self.profile
            previous_health = self.health_state()
            self.machine.exit()
            self.machine = create_machine(profile)
            self._configure_machine(self.machine)
            self.machine.enter()
            self._prepare_and_join()
            self._restore_health(previous_health)
            self.profile = profile
            self.log.append({"event": "profile_changed", "from": old, "to": profile})
    def _restore_health(self, health):
        target_index = next((i for i, (state, _) in enumerate(self.HEALTH_STATES) if state == "health_" + health.lower()), 0)
        for index in range(1, target_index + 1):
            _, event = self.HEALTH_STATES[index]
            if event:
                method = getattr(self.machine.hm, "raise_" + event, None)
                if method:
                    method()
    def update_physical_state(self, now):
        reading = self.unit.update(now)
        if self.name == "RescueBoat" and reading.get("hull_water_level", 0) >= 0.48:
            self._advance_health_to("Degraded")
        elif self.name == "RescueBoat" and reading.get("hull_water_level", 0) >= 0.32:
            self._advance_health_to("Malfunctioning")
        elif self.name == "UAV" and reading.get("battery", 100) < 25:
            self._advance_health_to("Defective")
        elif self.name == "MonitoringBoat" and reading.get("battery", 100) < 20:
            self._advance_health_to("Defective")
        elif not self.unit.operational:
            self._advance_health_to("Failed")
        return reading
    def _advance_health_to(self, target):
        target_index = next((i for i, (state, _) in enumerate(self.HEALTH_STATES) if state == "health_" + target.lower()), None)
        if target_index is None:
            return
        for index in range(1, target_index + 1):
            state, event = self.HEALTH_STATES[index]
            if not self.state_active(state) and event:
                method = getattr(self.machine.hm, "raise_" + event, None)
                if method:
                    method()
    def publish_telemetry(self, reading, now):
        payload = {"time": now, "unit": self.name, "role": self.unit.role, "reading": reading, "health": self.health_state(), "belonging": self.belonging_state(), "profile": self.profile, "connected": self.connected, "operational": self.unit.operational}
        self.last_telemetry = payload
        if self.connected:
            self.broker.publish("telemetry", payload, self.name)
    def receive_command(self, command):
        action = command.get("action")
        if action == "restrict_role":
            self.role_restricted = True
        elif action == "restore_role":
            self.role_restricted = False
        elif action == "task":
            self.task = command.get("task")
        elif action == "withdraw":
            self._raise_first_available(self.machine.bm, ["raise_leave_constellation", "raise_leave_so_s", "raise_leave_sos", "raise_disengage"])
        elif action in {"rescue", "pump", "monitor"}:
            result = self.unit.execute(command)
            self.broker.publish("task_result", {"unit": self.name, "action": action, "result": result, "time": self.broker.env.now}, self.name)
    def disconnect(self):
        self.connected = False
        self.log.append({"event": "disconnected", "time": self.broker.env.now})
    def reconnect(self):
        self.connected = True
        self.log.append({"event": "reconnected", "time": self.broker.env.now})
        self.publish_telemetry(self.last_telemetry.get("reading", {}), self.broker.env.now)
    def announce(self):
        pass
    def _configure_machine(self, machine):
        machine.bm.operation_callback = self
        if hasattr(machine, "timer_service"):
            machine.timer_service = self.timer_service
