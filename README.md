# Model-Driven Adaptive Resilience Policies for Digital-Twin-Enabled Systems of Systems

This repository is the replication package for the paper **“Model-Driven Adaptive Resilience Policies for Digital-Twin-Enabled Systems of Systems.”** It provides model specifications, statecharts for four resilience profiles, generated Python implementations, and a flood-response simulator with an analysis notebook.

The package supports a descriptive evaluation of how resilience-policy adaptation relates to mission success, constituent autonomy, and resource cost.

## Repository structure

```text
.
├── profiles/                     Textual model and profile specifications (.relp)
├── itemis-create/
│   ├── *.scm                     Resilience-profile statechart models
│   ├── figs/                     Statechart figures (SVG)
│   ├── src/                      Generated Python state machines and supporting code
│   └── tests/                    Statechart test artifacts
└── prototype/
    └── flood_sos/
        ├── README.md             Detailed prototype instructions
        ├── requirements.md       Simulation and experiment requirements
        ├── requirements.txt      Simulator dependencies
        ├── src/                  Simulation implementation
        │   └── generated/        Generated profile state machines
        ├── docs/                 Architecture diagram and documentation
        ├── analysis.ipynb        Plots and printed numeric summaries
        ├── output/               Simulation results
        └── plots/                Figures exported by the notebook
```

### Model specifications

The [profiles](profiles/) directory contains textual specifications of constituent health, SoS belonging, and the **Reactive**, **Proactive**, **Controlled**, and **Adaptive** resilience profiles. The specifications describe states, transitions, and profile-specific interactions using the approach's domain-specific language. The model-file extension is `.relp`; existing `.txt` files are being migrated to this extension.

### Statechart models and generated code

The [itemis-create](itemis-create/) directory contains the four profile statecharts, their exported figures, Python implementations generated using itemis CREATE, and statechart test artifacts.

The simulator uses the generated profile implementations in [prototype/flood_sos/src/generated](prototype/flood_sos/src/generated/). It raises events through their health (`hm`) and belonging (`bm`) interfaces and observes the resulting transitions. **Files inside `generated/` must not be modified manually.**

### Flood-response prototype

The [prototype](prototype/flood_sos/) implements a flood-response mission involving boats, a drone, and a pumping station, each represented by a digital twin. SimPy schedules flood evolution, physical deterioration, task execution, communication, and coordination on a virtual simulation clock.

The experiments compare three strategies:

- **Static permissive:** Reactive profiles throughout the mission.
- **Static restrictive:** Adaptive profiles throughout the mission.
- **Dynamic:** profiles change according to flood severity and constituent role.

Three autonomous departure-request-rate conditions are evaluated: **Low**, **Reference**, and **High**. The simulator also models health-dependent participation, repairs, reserve activation, and activity-based cost estimation.

## Simulator architecture

[![Simulator architecture](prototype/flood_sos/docs/architecture.png)](prototype/flood_sos/docs/architecture.pdf)
 

The experiment runner loads the configuration and executes the simulation using SimPy. The coordinator assigns profiles and manages participation and mission tasks. Each digital twin connects a physical unit to a generated resilience-profile state machine, which governs its health and belonging transitions. The flood environment and scenario processes provide operational conditions and disturbances, while the message broker carries telemetry and task results. Recorded activity quantities feed the ABC cost model, and the resulting traces and metrics support the analysis notebook.

## Replication instructions

The **[prototype README](prototype/flood_sos/README.md)** provides detailed installation, execution, configuration, and analysis instructions. Refer to it for command-line options and analysis dependencies.

To run the default experiments from the repository root:

```shell
cd prototype/flood_sos
python -m pip install -r requirements.txt
python src/main.py
```

Use Python 3.10 or newer. The supplied generated state machines allow the simulator to run without installing itemis CREATE.

After generating the results, open [analysis.ipynb](prototype/flood_sos/analysis.ipynb) in a Jupyter environment with the analysis dependencies installed. The notebook produces evaluation plots and prints their underlying numeric values using the same terminology and filters as the plots.

## Results and analysis

Simulation results are written to `prototype/flood_sos/output/` by default:

| File | Contents |
| --- | --- |
| `simulation_runs.csv` | Run-level mission outcomes, participation, resource use, departure-request metrics, retention, and cost estimates |
| `flood_history.csv` | Flood conditions and mission-objective achievement over simulated time |
| `simulation_summary.json` | Experiment settings, aggregate results, run details, state transitions, and coordinator events |

The analysis notebook exports figures to `prototype/flood_sos/plots/`. Metrics include mission success, objective achievement, health and belonging transitions, task outcomes, repairs, replacements, departure denials and deferrals, forced-retention time, and cost estimates.

Strategies use matching random seeds and common scenario inputs. Actual event sequences may differ as participation and operational conditions evolve. The evaluation interprets quantitative metrics and execution traces descriptively within the modeled scenarios.


