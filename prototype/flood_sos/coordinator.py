from config import PROFILE_LEVELS, FLOOD_THRESHOLDS, SIMULATION

class SoSCoordinator:
    def __init__(self, env, broker, flood, twins):
        self.env = env
        self.broker = broker
        self.flood = flood
        self.twins = {t.name: t for t in twins}
        self.latest = {}
        self.events = []
        self.assignments = {}
        self.broker.subscribe("telemetry", self.on_telemetry)
        self.broker.subscribe("task_result", self.on_task_result)
    def on_telemetry(self, payload, source):
        self.latest[source] = payload
        self.events.append({"time": self.env.now, "event": "telemetry_received", "unit": source, "health": payload.get("health"), "connected": payload.get("connected")})
    def on_task_result(self, payload, source):
        self.events.append({"time": self.env.now, "event": "task_result", "unit": source, "action": payload.get("action"), "result": payload.get("result")})
    def flood_severity(self):
        return min(5, int(self.flood.water_level))
    def update_profiles(self):
        severity = self.flood_severity()
        for name, twin in self.twins.items():
            target = twin.unit.config["target_profile"]
            promote = target == "Proactive" and severity >= FLOOD_THRESHOLDS["Proactive"]
            promote = promote or target == "Controlled" and severity >= FLOOD_THRESHOLDS["Controlled"]
            promote = promote or target == "Adaptive" and severity >= FLOOD_THRESHOLDS["Adaptive"]
            if promote:
                old = twin.profile
                twin.set_profile(target)
                if twin.profile != old:
                    self.events.append({"time": self.env.now, "event": "profile_changed", "unit": name, "from": old, "to": twin.profile, "flood_severity": severity})
    def adapt_to_health(self):
        for name, twin in self.twins.items():
            health = twin.health_state()
            if health in {"Malfunctioning", "Erroneous"} and twin.profile == "Adaptive":
                twin.receive_command({"action": "restrict_role"})
                self.events.append({"time": self.env.now, "event": "role_restricted", "unit": name, "health": health})
            if health in {"Degraded", "Failed"}:
                twin.receive_command({"action": "withdraw"})
                self.events.append({"time": self.env.now, "event": "withdrawal_requested", "unit": name, "health": health})
                if name == "RescueBoat":
                    self.reassign_rescue()
    def reassign_rescue(self):
        monitoring = self.twins.get("MonitoringBoat")
        if monitoring and monitoring.unit.operational and monitoring.connected and monitoring.health_state() in {"Ideal", "Defective", "Faulty"}:
            self.assignments["rescue"] = "MonitoringBoat"
            self.events.append({"time": self.env.now, "event": "rescue_reassigned", "to": "MonitoringBoat"})
        else:
            self.events.append({"time": self.env.now, "event": "human_escalation", "reason": "No suitable rescue unit available"})
    def dispatch_tasks(self):
        rescue = self.twins["RescueBoat"]
        pump = self.twins["PumpingStation"]
        uav = self.twins["UAV"]
        monitor = self.twins["MonitoringBoat"]
        if uav.unit.operational and uav.connected:
            uav.receive_command({"action": "monitor"})
        if monitor.unit.operational and monitor.connected:
            monitor.receive_command({"action": "monitor"})
        if pump.unit.operational and pump.connected:
            pump.receive_command({"action": "pump", "amount": SIMULATION["pump_reduction_per_step"]})
        if rescue.unit.operational and rescue.connected and not rescue.role_restricted and rescue.health_state() not in {"Degraded", "Failed"}:
            rescue.receive_command({"action": "rescue", "capacity": 2 if rescue.health_state() in {"Ideal", "Defective", "Faulty"} else 1})
    def run(self):
        while True:
            self.update_profiles()
            self.adapt_to_health()
            self.dispatch_tasks()
            yield self.env.timeout(SIMULATION["step"])
