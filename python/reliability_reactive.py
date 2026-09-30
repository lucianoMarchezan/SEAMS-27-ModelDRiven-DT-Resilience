from health import Health
from belonging import Belonging


class ReactiveReliability:
    def __init__(self):
        self.health = Health()
        self.belonging = Belonging(self.health)