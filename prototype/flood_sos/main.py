import csv
import json
import simpy
from config import SIMULATION, UNIT_CONFIG
from communication import MessageBroker
from coordinator import SoSCoordinator
from digital_twin import DigitalTwin
from environment import FloodEnvironment
from physical_units import PhysicalUnit
from scenarios import apply_connectivity_scenario, run_twins
from digital_twin import create_machine

def main():
    env = simpy.Environment()
    flood = FloodEnvironment(env)
    broker = MessageBroker(env, SIMULATION["message_latency"], SIMULATION["message_loss_probability"], seed=7)
    twins = [DigitalTwin(name, PhysicalUnit(name, flood), broker, create_machine("Reactive"), "Reactive") for name in UNIT_CONFIG]
    coordinator = SoSCoordinator(env, broker, flood, twins)
    env.process(flood.run())
    env.process(run_twins(env, twins))
    env.process(apply_connectivity_scenario(env, twins))
    env.process(coordinator.run())
    env.process(monitor_simulation(env, flood, twins))
    env.run(until=SIMULATION["duration"])
    with open("simulation_summary.json", "w", encoding="utf-8") as file:
        json.dump({"final_water_level": flood.water_level, "flooded_area": flood.flooded_area, "victims_waiting": flood.victims_waiting, "victims_rescued": flood.victims_rescued, "pumped_water": flood.pumped_water, "profiles": {t.name: t.profile for t in twins}, "health": {t.name: t.health_state() for t in twins}, "belonging": {t.name: t.belonging_state() for t in twins}, "coordinator_events": coordinator.events, "communication_events": broker.log, "twin_events": {t.name: t.log for t in twins}}, file, indent=2)
    with open("flood_history.csv", "w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=["time", "water_level", "flooded_area", "victims_waiting", "victims_rescued"])
        writer.writeheader()
        writer.writerows(flood.history)
    print(json.dumps({"final_water_level": round(flood.water_level, 2), "victims_rescued": flood.victims_rescued, "victims_waiting": flood.victims_waiting, "profiles": {t.name: t.profile for t in twins}, "health": {t.name: t.health_state() for t in twins}}, indent=2))

def monitor_simulation(env, flood, units, interval=1):
    while True:
        print(f"\n--- Simulation time: {env.now:.1f} ---")
        print(f"Water level: {flood.water_level:.2f}")
        print(f"Flooded area: {flood.flooded_area:.2f}")
        print(f"Victims rescued: {flood.victims_rescued}")
        print(f"Victims waiting: {flood.victims_waiting}")

        for twin in units:
            print(
                f"{twin.name}: "
                f"profile={twin.profile}, "
                f"health={twin.health_state()}, "
                f"belonging={twin.belonging_state()}, "
                f"connected={twin.connected}"
            )

        yield env.timeout(interval)


if __name__ == "__main__":
    main()


