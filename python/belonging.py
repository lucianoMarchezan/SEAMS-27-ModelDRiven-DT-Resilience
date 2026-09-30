from statemachine import StateChart, State, Event


class Belonging(StateChart):
    disengaged = State(initial=True)
    prepared = State()
    passive = State()
    active = State()

    prepare_for_sos = Event(disengaged.to(prepared))
    disengage_from_sos = Event(prepared.to(disengaged))

    join_sos = Event(prepared.to(passive))
    leave_sos = Event(passive.to(prepared))

    join_constellation = (
        passive.to(active, cond="health_not_failed")
        | passive.to(passive)
    )

    leave_constellation = Event(active.to(passive))

    def __init__(self, health):
        self.health = health
        super().__init__()

    def health_not_failed(self):
        return not self.health.failed.is_active