from statemachine import StateChart, State, Event


class Health(StateChart):
    ideal = State(initial=True)
    defective = State()
    faulty = State()
    erroneous = State()
    malfunctioning = State()
    degraded = State()
    failed = State()

    component_deviation = Event(ideal.to(defective))
    defect_activated = Event(defective.to(faulty))
    fault_exercised = Event(faulty.to(erroneous))
    error_propagated = Event(erroneous.to(malfunctioning))
    impact_observed = Event(malfunctioning.to(degraded))
    threshold_violated = Event(degraded.to(failed))

    recovery = Event(
        defective.to(ideal)
        | faulty.to(ideal)
        | erroneous.to(ideal)
        | malfunctioning.to(ideal)
        | degraded.to(ideal)
        | failed.to(ideal)
    )