from config import SIMULATION, UNIT_CONFIG


class PhysicalUnit:
    def __init__(self, name, environment):
        self.name = name
        self.environment = environment
        self.config = UNIT_CONFIG[name]
        self.asset_type = self.config["asset_type"]
        self.role = self.config["role"]
        self.position = [0.0, 0.0]
        self.battery = self.config["battery"]
        self.connected = True
        self.operational = True
        self.hull_water_level = 0.0
        self.fault_exposure = 0.0
        self.rescue_progress = 0.0
        self.task = None
        self.last_reading = {}

    def record_flood_exposure(self, water_level):
        """Accumulate environmental exposure that can damage this physical unit."""
        if water_level >= SIMULATION["fault_water_level_threshold"] and self.operational:
            self.fault_exposure += SIMULATION["fault_exposure_per_step"]
        interval = SIMULATION["fault_exposure_per_transition"]
        if interval <= 0:
            return False
        if self.fault_exposure >= interval:
            self.fault_exposure -= interval
            return True
        return False

    def repair(self):
        self.operational = True
        self.battery = self.config["battery"]
        self.hull_water_level = 0.0
        self.fault_exposure = 0.0
        self.rescue_progress = 0.0

    def set_role(self, role):
        if self.asset_type == "boat":
            self.role = role

    def update(self, now):
        active = self.role != "reserve"
        if self.asset_type != "pump" and active:
            battery_use = 0.35 if self.asset_type == "drone" else 0.15
            self.battery = max(0.0, self.battery - battery_use)

        if self.asset_type == "drone":
            self.position[0] += self.config["speed"] * 0.01
            self.last_reading = {
                "water_level": self.environment.water_level,
                "flooded_area": self.environment.flooded_area,
                "victims_detected": self.environment.victims_waiting,
                "battery": self.battery,
                "position": tuple(self.position),
            }
        elif self.asset_type == "boat":
            if active:
                self.position[1] += self.config["speed"] * 0.01
                if now >= SIMULATION["boat_water_ingress_step"]:
                    self.hull_water_level += SIMULATION["boat_water_ingress_per_step"]
            self.last_reading = {
                "water_level": self.environment.water_level,
                "flooded_area": self.environment.flooded_area,
                "hull_water_level": self.hull_water_level,
                "battery": self.battery,
                "position": tuple(self.position),
                "role": self.role,
            }
        else:
            self.last_reading = {
                "water_level": self.environment.water_level,
                "pumped_water": self.environment.pumped_water,
                "operational": self.operational,
            }

        if self.battery <= 0 and self.asset_type != "pump":
            self.operational = False
        return dict(self.last_reading)

    def execute(self, command):
        action = command["action"]
        if action == "rescue" and self.asset_type == "boat" and self.role == "rescue" and self.operational:
            if self.environment.victims_waiting == 0:
                self.rescue_progress = 0.0
                return {"rescued": 0}
            area_factor = 1.0 + self.environment.flooded_area * SIMULATION["rescue_area_penalty"]
            self.rescue_progress += command.get("capacity", 2) / area_factor
            rescuable = int(self.rescue_progress)
            if rescuable <= 0:
                return {"rescued": 0}
            rescued = self.environment.rescue(rescuable)
            self.rescue_progress = self.rescue_progress - rescued if rescued == rescuable else 0.0
            return {"rescued": rescued}
        if action == "pump" and self.asset_type == "pump" and self.operational:
            return {"water_reduced": self.environment.apply_pumping(command.get("amount", 0.12))}
        if action == "monitor" and self.asset_type in {"drone", "boat"} and self.operational:
            return {"observation": dict(self.last_reading)}
        return {"executed": False}
