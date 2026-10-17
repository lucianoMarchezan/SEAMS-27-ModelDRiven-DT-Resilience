from config import SIMULATION


class FloodEnvironment:
    def __init__(self, env):
        self.env = env
        self.water_level = SIMULATION["initial_water_level"]
        self.max_water_level = self.water_level
        self.pumped_water = 0.0
        self.flooded_area = max(1.0, self.water_level * 2.5)
        self.victims = []
        self.victims_rescued = 0
        self.victims_rescued_before_deadline = 0
        self.victims_expired = 0
        self.observed_locations = set()
        self.history = []
        self._next_victim_id = 1
        self._spawn_victims(SIMULATION["initial_victims"])
        self._victim_arrival_waves = sorted(
            SIMULATION.get("victim_arrival_waves", []), key=lambda wave: wave["time"]
        )
        self._next_victim_wave = 0

    @property
    def victims_waiting(self):
        return sum(victim["status"] == "waiting" for victim in self.victims)

    @property
    def total_victims(self):
        return len(self.victims)

    @property
    def victims_per_area(self):
        return self.victims_waiting / max(self.flooded_area, 1.0)

    def _spawn_victims(self, count):
        for _ in range(max(0, count)):
            self.victims.append(
                {
                    "id": self._next_victim_id,
                    "arrived_at": self.env.now,
                    "deadline": self.env.now + SIMULATION["victim_survival_time"],
                    "status": "waiting",
                }
            )
            self._next_victim_id += 1

    def run(self):
        while True:
            yield self.env.timeout(SIMULATION["step"])
            self.water_level += SIMULATION["water_rise_per_step"]
            self.max_water_level = max(self.max_water_level, self.water_level)
            self.flooded_area = max(1.0, self.water_level * 2.5)

            while (
                self._next_victim_wave < len(self._victim_arrival_waves)
                and self._victim_arrival_waves[self._next_victim_wave]["time"] <= self.env.now
            ):
                wave = self._victim_arrival_waves[self._next_victim_wave]
                self._spawn_victims(wave["count"])
                self._next_victim_wave += 1

            self.expire_victims()
            self.history.append(
                {
                    "time": self.env.now,
                    "water_level": round(self.water_level, 3),
                    "flooded_area": round(self.flooded_area, 3),
                    "victims_waiting": self.victims_waiting,
                    "victims_rescued": self.victims_rescued,
                    "victims_rescued_before_deadline": self.victims_rescued_before_deadline,
                    "victims_expired": self.victims_expired,
                    "total_victims": self.total_victims,
                    "victims_per_area": round(self.victims_per_area, 4),
                }
            )

    def expire_victims(self):
        for victim in self.victims:
            if victim["status"] == "waiting" and self.env.now >= victim["deadline"]:
                victim["status"] = "expired"
                self.victims_expired += 1

    def apply_pumping(self, amount):
        reduction = min(amount, max(0.0, self.water_level - 0.5))
        self.water_level -= reduction
        self.flooded_area = max(1.0, self.water_level * 2.5)
        self.pumped_water += reduction
        return reduction

    def rescue(self, capacity):
        self.expire_victims()
        waiting = sorted(
            (victim for victim in self.victims if victim["status"] == "waiting"),
            key=lambda victim: victim["deadline"],
        )
        rescued = waiting[: max(0, int(capacity))]
        for victim in rescued:
            victim["status"] = "rescued"
            self.victims_rescued += 1
            self.victims_rescued_before_deadline += 1
        return len(rescued)
