from config import SIMULATION


class FloodEnvironment:
    def __init__(self, env):
        self.env = env
        self.water_level = SIMULATION["initial_water_level"]
        self.max_water_level = self.water_level
        self.storage_volume_m3 = self._storage_for_level(self.water_level)
        self.pumped_water = 0.0
        self.flood_inflow_m3 = 0.0
        self.flooded_area = self._area_hectares_for_level(self.water_level)
        self.mission_targets = []
        self.mission_targets_completed = 0
        self.mission_targets_completed_before_deadline = 0
        self.mission_targets_expired = 0
        self.history = []
        self._next_mission_target_id = 1
        self._spawn_mission_targets(SIMULATION["initial_mission_targets"])
        self._mission_target_arrival_schedule = sorted(
            SIMULATION.get("mission_target_arrival_schedule", []), key=lambda wave: wave["time"]
        )
        self._next_mission_target_wave = 0

    @staticmethod
    def _area_m2_for_level(level_m):
        return (
            SIMULATION["storage_area_base_m2"]
            + SIMULATION["storage_area_expansion_m2_per_m"] * max(0.0, level_m)
        )

    @classmethod
    def _storage_for_level(cls, level_m):
        base = SIMULATION["storage_area_base_m2"]
        expansion = SIMULATION["storage_area_expansion_m2_per_m"]
        level = max(0.0, level_m)
        return base * level + 0.5 * expansion * level * level

    @staticmethod
    def _area_hectares_for_level(level_m):
        return FloodEnvironment._area_m2_for_level(level_m) / 10000.0

    @staticmethod
    def _level_for_storage(volume_m3):
        base = SIMULATION["storage_area_base_m2"]
        expansion = SIMULATION["storage_area_expansion_m2_per_m"]
        if expansion <= 0:
            return max(0.0, volume_m3 / base)
        return max(0.0, (-base + (base * base + 2 * expansion * max(0.0, volume_m3)) ** 0.5) / expansion)

    @property
    def mission_targets_waiting(self):
        return sum(mission_target["status"] == "waiting" for mission_target in self.mission_targets)

    @property
    def total_mission_targets(self):
        return len(self.mission_targets)

    @property
    def mission_targets_per_area(self):
        return self.mission_targets_waiting / max(self.flooded_area, 1.0)

    def _spawn_mission_targets(self, count):
        for _ in range(max(0, count)):
            self.mission_targets.append(
                {
                    "id": self._next_mission_target_id,
                    "arrived_at": self.env.now,
                    "deadline": self.env.now + SIMULATION["mission_target_deadline_interval"],
                    "status": "waiting",
                }
            )
            self._next_mission_target_id += 1

    def run(self):
        while self.env.now < SIMULATION["duration"]:
            yield self.env.timeout(SIMULATION["step"])
            if self.env.now > SIMULATION["duration"]:
                return
            interval_minutes = SIMULATION["step"] / 60.0
            inflow = SIMULATION["flood_inflow_m3_per_minute"] * interval_minutes
            self.storage_volume_m3 += inflow
            self.flood_inflow_m3 += inflow
            self.water_level = self._level_for_storage(self.storage_volume_m3)
            self.max_water_level = max(self.max_water_level, self.water_level)
            self.flooded_area = self._area_hectares_for_level(self.water_level)

            while (
                self._next_mission_target_wave < len(self._mission_target_arrival_schedule)
                and self._mission_target_arrival_schedule[self._next_mission_target_wave]["time"] <= self.env.now
            ):
                wave = self._mission_target_arrival_schedule[self._next_mission_target_wave]
                self._spawn_mission_targets(wave["count"])
                self._next_mission_target_wave += 1

            self.expire_mission_targets()
            self.history.append(
                {
                    "time": self.env.now,
                    "time_minutes": round(self.env.now / 60.0, 3),
                    "water_level_m": round(self.water_level, 3),
                    "storage_volume_m3": round(self.storage_volume_m3, 3),
                    "flood_inflow_m3": round(self.flood_inflow_m3, 3),
                    "pumped_water_m3": round(self.pumped_water, 3),
                    "flooded_area_hectares": round(self.flooded_area, 3),
                    "mission_targets_waiting": self.mission_targets_waiting,
                    "mission_targets_completed": self.mission_targets_completed,
                    "mission_targets_completed_before_deadline": self.mission_targets_completed_before_deadline,
                    "mission_objective_achievement": self.mission_targets_completed_before_deadline,
                    "mission_targets_expired": self.mission_targets_expired,
                    "total_mission_targets": self.total_mission_targets,
                    "mission_targets_per_hectare": round(self.mission_targets_per_area, 4),
                }
            )
            if self.env.now >= SIMULATION["duration"]:
                return

    def expire_mission_targets(self):
        for mission_target in self.mission_targets:
            if mission_target["status"] == "waiting" and self.env.now >= mission_target["deadline"]:
                mission_target["status"] = "expired"
                self.mission_targets_expired += 1

    def apply_pumping(self, volume_m3):
        removed = min(max(0.0, volume_m3), self.storage_volume_m3)
        self.storage_volume_m3 -= removed
        self.pumped_water += removed
        self.water_level = self._level_for_storage(self.storage_volume_m3)
        self.flooded_area = self._area_hectares_for_level(self.water_level)
        return removed

    def rescue(self, capacity):
        self.expire_mission_targets()
        waiting = sorted(
            (mission_target for mission_target in self.mission_targets if mission_target["status"] == "waiting"),
            key=lambda mission_target: mission_target["deadline"],
        )
        completed = waiting[: max(0, int(capacity))]
        for mission_target in completed:
            mission_target["status"] = "completed"
            self.mission_targets_completed += 1
            self.mission_targets_completed_before_deadline += 1
        return len(completed)
