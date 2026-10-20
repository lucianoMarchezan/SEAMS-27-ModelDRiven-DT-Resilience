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
        self.last_reading = {}
        self.last_update_time = 0.0
        self.last_exposure_update_time = 0.0

    def record_flood_exposure(self, water_level, now, exposed):
        """Integrate environmental exposure over elapsed simulated minutes."""
        elapsed_minutes = max(0.0, now - self.last_exposure_update_time) / 60.0
        self.last_exposure_update_time = now
        if (
            exposed
            and water_level >= SIMULATION["fault_water_level_threshold"]
            and self.operational
        ):
            self.fault_exposure += SIMULATION["fault_exposure_per_minute"] * elapsed_minutes
        interval = SIMULATION["fault_exposure_per_transition"]
        if interval <= 0:
            return 0
        transitions = int(self.fault_exposure // interval)
        self.fault_exposure -= transitions * interval
        return transitions

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
        elapsed_minutes = max(0.0, now - self.last_update_time) / 60.0
        active = self.role != "reserve"
        if self.asset_type != "pump" and active:
            battery_use_per_minute = 1.5 if self.asset_type == "drone" else 0.75
            self.battery = max(0.0, self.battery - battery_use_per_minute * elapsed_minutes)

        if self.asset_type == "drone":
            self.position[0] += self.config["speed"] * elapsed_minutes
            self.last_reading = {
                "water_level": self.environment.water_level,
                "flooded_area": self.environment.flooded_area,
                "mission_targets_detected": self.environment.mission_targets_waiting,
                "battery": self.battery,
                "position": tuple(self.position),
            }
        elif self.asset_type == "boat":
            if active:
                self.position[1] += self.config["speed"] * elapsed_minutes
                ingress_minutes = max(
                    0.0,
                    now
                    - max(
                        self.last_update_time,
                        SIMULATION["boat_water_ingress_start_time"],
                    ),
                ) / 60.0
                self.hull_water_level += (
                    SIMULATION["boat_water_ingress_m_per_minute"] * ingress_minutes
                )
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
        self.last_update_time = now
        return dict(self.last_reading)

    def execute(self, command):
        action = command["action"]
        if action == "rescue" and self.asset_type == "boat" and self.role == "rescue" and self.operational:
            if self.environment.mission_targets_waiting == 0:
                self.rescue_progress = 0.0
                return {"completed": 0}
            area_factor = 1.0 + self.environment.flooded_area * SIMULATION["rescue_area_penalty"]
            self.rescue_progress += command.get("capacity", 2) / area_factor
            rescuable = int(self.rescue_progress)
            if rescuable <= 0:
                return {"completed": 0}
            completed = self.environment.rescue(rescuable)
            self.rescue_progress = self.rescue_progress - completed if completed == rescuable else 0.0
            return {"completed": completed}
        if action == "pump" and self.asset_type == "pump" and self.operational:
            return {"water_removed_m3": self.environment.apply_pumping(command.get("amount_m3", 0.0))}
        if action == "monitor" and self.asset_type in {"drone", "boat"} and self.operational:
            return {"observation": dict(self.last_reading)}
        return {"executed": False}
