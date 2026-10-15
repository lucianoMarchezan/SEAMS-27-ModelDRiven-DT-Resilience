from config import UNIT_CONFIG, SIMULATION

class PhysicalUnit:
    def __init__(self, name, environment):
        self.name = name
        self.environment = environment
        self.config = UNIT_CONFIG[name]
        self.role = self.config["role"]
        self.position = [0.0, 0.0]
        self.battery = self.config["battery"]
        self.connected = True
        self.operational = True
        self.hull_water_level = 0.0
        self.task = None
        self.last_reading = {}
    def update(self, now):
        if self.name != "PumpingStation":
            self.battery = max(0.0, self.battery - (0.35 if self.name == "UAV" else 0.15))
        if self.name == "UAV":
            self.position[0] += self.config["speed"] * 0.01
            self.last_reading = {"water_level": self.environment.water_level, "flooded_area": self.environment.flooded_area, "victims_detected": self.environment.victims_waiting, "battery": self.battery, "position": tuple(self.position)}
        elif self.name == "RescueBoat":
            self.position[1] += self.config["speed"] * 0.01
            if now >= SIMULATION["rescue_boat_water_ingress_step"]:
                self.hull_water_level += 0.16
            self.last_reading = {"water_level": self.environment.water_level, "hull_water_level": self.hull_water_level, "battery": self.battery, "position": tuple(self.position)}
        elif self.name == "MonitoringBoat":
            self.position[0] += self.config["speed"] * 0.01
            self.last_reading = {"water_level": self.environment.water_level, "flooded_area": self.environment.flooded_area, "battery": self.battery, "position": tuple(self.position)}
        else:
            self.last_reading = {"water_level": self.environment.water_level, "pumped_water": self.environment.pumped_water, "operational": self.operational}
        if self.battery <= 0 and self.name != "PumpingStation":
            self.operational = False
        return dict(self.last_reading)
    def execute(self, command):
        if command["action"] == "rescue" and self.name == "RescueBoat" and self.operational:
            return {"rescued": self.environment.rescue(command.get("capacity", 2))}
        if command["action"] == "pump" and self.name == "PumpingStation" and self.operational:
            return {"water_reduced": self.environment.apply_pumping(command.get("amount", 0.12))}
        if command["action"] == "monitor" and self.name in {"UAV", "MonitoringBoat"} and self.operational:
            return {"observation": dict(self.last_reading)}
        return {"executed": False}
