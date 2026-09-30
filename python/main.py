from reliability_reactive import ReactiveReliability


def show_state(system, label):
    print(
        f"{label}: "
        f"Health={system.health.configuration}, "
        f"Belonging={system.belonging.configuration}"
    )


system = ReactiveReliability()
system.health._graph().write_png("diagrams/health.png")
system.belonging._graph().write_png("diagrams/belonging.png")
print("Health State Machine:")
print(f"{system.health:md}")

print("\nBelonging State Machine:")
print(f"{system.belonging:md}")
print("=== Initial State ===")
show_state(system, "Initial")


print("\n=== Move Belonging to Passive ===")

system.belonging.send("prepare_for_sos")
system.belonging.send("join_sos")

show_state(system, "After join-sos")


print("\n=== Make Health Failed ===")

system.health.send("component_deviation")
system.health.send("defect_activated")
system.health.send("fault_exercised")
system.health.send("error_propagated")
system.health.send("impact_observed")
system.health.send("threshold_violated")

show_state(system, "Health failed")


print("\n=== Try Passive -> Active when Health Failed ===")

system.belonging.send("join_constellation")
show_state(system, "After join-constellation")

print("\n=== Restore Health ===")

system.health.send("recovery")
show_state(system, "After recovery")

print("\n=== Try Passive -> Active when Health != Failed ===")

system.belonging.send("join_constellation")

show_state(system, "After join-constellation")