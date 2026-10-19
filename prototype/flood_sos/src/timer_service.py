import simpy


class TimerService:
    def __init__(self, env):
        self.env = env
        self.timers = {}

    def set_timer(self, state_machine, event_id, duration_ms, is_periodic):
        self.unset_timer(state_machine, event_id)
        key = (id(state_machine), event_id)

        def wait():
            try:
                # Generated statecharts use milliseconds; SimPy's base unit
                # for this simulation is seconds.
                yield self.env.timeout(duration_ms / 1000)
            except simpy.Interrupt:
                # State-machine transitions cancel timers by interrupting the
                # SimPy process. That is normal cancellation, not a simulation
                # failure.
                return

            if self.timers.get(key) is process:
                del self.timers[key]
                state_machine.time_elapsed(event_id)
                if is_periodic and key not in self.timers:
                    self.set_timer(state_machine, event_id, duration_ms, is_periodic)

        process = self.env.process(wait())
        self.timers[key] = process

    def unset_timer(self, state_machine, event_id):
        key = (id(state_machine), event_id)
        process = self.timers.pop(key, None)
        if process is not None and process.is_alive:
            process.interrupt()
