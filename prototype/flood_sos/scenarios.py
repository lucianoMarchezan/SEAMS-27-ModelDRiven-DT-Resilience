from config import SIMULATION

def apply_connectivity_scenario(env, twins):
    boat = next(t for t in twins if t.name == "RescueBoat")
    yield env.timeout(SIMULATION["boat_disconnect_step"])
    boat.disconnect()
    yield env.timeout(SIMULATION["boat_disconnect_duration"])
    boat.reconnect()

def run_twins(env, twins):
    while True:
        for twin in twins:
            reading = twin.update_physical_state(env.now)
            twin.publish_telemetry(reading, env.now)
        yield env.timeout(SIMULATION["telemetry_interval"])
