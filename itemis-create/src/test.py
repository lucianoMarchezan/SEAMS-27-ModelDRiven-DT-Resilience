from belonging import Belonging

sm = Belonging()
sm.enter()

print("=== Initial State ===")
print("Health is Ideal:", sm.is_state_active(Belonging.State.health_ideal))
print("Belonging is Disengaged:", sm.is_state_active(Belonging.State.belonging_desingaged))

print("\n=== Transition: Disengaged -> Prepared ===")
print("Manually triggering: prepare_for_sos")
sm.bm.raise_prepare_for_sos()
print("Belonging is Prepared:", sm.is_state_active(Belonging.State.belonging_prepared))

print("\n=== Transition: Prepared -> Passive ===")
print("Manually triggering: join_sos")
sm.bm.raise_join_so_s()
print("Belonging is Passive:", sm.is_state_active(Belonging.State.belonging_passive))

print("\n=== Transition: Passive -> Active ===")
print("Manually triggering: join_constellation")
sm.bm.raise_join_constellation()
print("Belonging is Active:", sm.is_state_active(Belonging.State.belonging_active))

print("\n=== Transition: Health Ideal -> Defective ===")
print("Manually triggering: component_deviation")
sm.hm.raise_component_deviation()
print("Health is Defective:", sm.is_state_active(Belonging.State.health_defective))

print("\n=== Resulting Belonging State ===")
print("Belonging is Passive:", sm.is_state_active(Belonging.State.belonging_passive))

print("\n=== Health transitions to Failed ===")
print("Manually triggering: Defective to Failed")
sm.hm.raise_defect_activated()
sm.hm.raise_fault_exercised()
sm.hm.raise_error_propagated()
sm.hm.raise_impact_observed()
sm.hm.raise_threshold_violated()
print("Health is Failed:", sm.is_state_active(Belonging.State.health_failed))


print("\n=== Transition: Passive -> Active ===")
print("Manually triggering: join_constellation")
sm.bm.raise_join_constellation()
print("Belonging is Active:", sm.is_state_active(Belonging.State.belonging_active))
print("Belonging is still Passive because Health is Failed:", sm.is_state_active(Belonging.State.belonging_passive))