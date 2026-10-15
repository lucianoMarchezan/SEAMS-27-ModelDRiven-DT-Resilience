# Flood-response DT SoS simulator

## Structure

- `main.py`: simulation entry point and output generation
- `environment.py`: flood progression, victim population, and pumping effects
- `physical_units.py`: physical behavior of the UAV, rescue boat, monitoring boat, and pumping station
- `digital_twin.py`: generated state-machine adapter, telemetry, connectivity, and commands
- `communication.py`: in-process publish/subscribe broker with latency and message loss
- `coordinator.py`: centralized task coordination, profile promotion, health-driven adaptation, and compensation
- `scenarios.py`: connectivity scenario and DT update loop
- `config.py`: scenario parameters and per-unit target profiles
- `generated/reactive.py`, `generated/proactive.py`, `generated/controlled.py`, `generated/adaptive.py`: copy the four ItemisCreate-generated state-machine modules here

## Run

Install Python 3.10 or newer, then run `python -m pip install -r requirements.txt`. Copy `reactive.py`, `proactive.py`, `controlled.py`, and `adaptive.py` into `generated/`, then run `python main.py`. The simulator starts every twin with the Reactive machine and replaces it with the appropriate generated machine when the coordinator promotes its profile.

Each generated module should expose a state-machine class named after its profile (`Reactive`, `Proactive`, `Controlled`, or `Adaptive`), or a class with the standard generated-machine interface. The adapter first looks for those class names and then searches the module for a class exposing `enter()`, `is_state_active()`, `State`, `bm`, and `hm`. State and event names are matched against the supplied usage example; adjust the adapter if your generated files use different names.

Each generated machine is expected to expose `enter()`, `State`, `is_state_active()`, `bm`, and `hm`, along with the shared health states/events. The adapter replays the current health state when switching profiles. Belonging withdrawal uses best-effort event-name lookup because the exact generated withdrawal event was not specified. Profile-specific behavior should be encoded in the generated state machines; the coordinator still handles centralized profile promotion, task allocation, and rescue compensation. The coordinator’s health-based role restrictions remain orchestration-level safeguards.

Profile promotion thresholds and physical dynamics are illustrative scenario parameters in `config.py` and should be calibrated to the experiment you intend to report.

Outputs are written to `simulation_summary.json` and `flood_history.csv`.
