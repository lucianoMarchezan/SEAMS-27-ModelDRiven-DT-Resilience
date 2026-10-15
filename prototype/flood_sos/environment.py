from config import SIMULATION

class FloodEnvironment:
    def __init__(self, env):
        self.env = env
        self.water_level = SIMULATION["initial_water_level"]
        self.pumped_water = 0.0
        self.flooded_area = 1.0
        self.victims_waiting = SIMULATION["initial_victims"]
        self.victims_rescued = 0
        self.observed_locations = set()
        self.history = []
    def run(self):
        while True:
            yield self.env.timeout(SIMULATION["step"])
            self.water_level += SIMULATION["water_rise_per_step"]
            self.flooded_area = max(1.0, self.water_level * 2.5)
            new_victims = int(self.water_level // 2) * SIMULATION["victims_per_flood_level"]
            self.victims_waiting = max(self.victims_waiting, SIMULATION["initial_victims"] + new_victims - self.victims_rescued)
            self.history.append({"time": self.env.now, "water_level": round(self.water_level, 3), "flooded_area": round(self.flooded_area, 3), "victims_waiting": self.victims_waiting, "victims_rescued": self.victims_rescued})
    def apply_pumping(self, amount):
        reduction = min(amount, max(0.0, self.water_level - 0.5))
        self.water_level -= reduction
        self.pumped_water += reduction
        return reduction
    def rescue(self, capacity):
        rescued = min(self.victims_waiting, capacity)
        self.victims_waiting -= rescued
        self.victims_rescued += rescued
        return rescued
