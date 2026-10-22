"""Compare flood inflows using the existing experiment and output pipeline."""

import argparse
from copy import deepcopy
import json
from pathlib import Path

from config import PROFILE_CONFIGS, PROFILE_STRATEGIES, RESCUE_SENSITIVITY_CONFIGS, SIMULATION
from main import aggregate_runs, run_simulation, write_outputs


FLOOD_CONDITIONS = {
    "slower": 0.5,
    "baseline": 1.0,
    "faster": 2.0,
}


def parse_args():
    parser = argparse.ArgumentParser(
        description="Compare slower (0.5x), baseline (1x), and faster (2x) flood inflows."
    )
    parser.add_argument(
        "--flood-condition",
        choices=["additional", "all", *FLOOD_CONDITIONS],
        default="additional",
        help="Flood case to run; 'additional' runs slower and faster only (default).",
    )
    parser.add_argument(
        "--scenario", choices=["all", *PROFILE_STRATEGIES], default="all",
        help="Policy strategy; 'all' compares all three strategies (default).",
    )
    parser.add_argument(
        "--profile-config", choices=["all", *PROFILE_CONFIGS], default="all",
        help="Autonomous departure-request-rate condition (default: all).",
    )
    parser.add_argument(
        "--rescue-sensitivity", choices=["all", *RESCUE_SENSITIVITY_CONFIGS],
        default="boat_emphasis", help="Boat-throughput/area condition (default: boat_emphasis).",
    )
    parser.add_argument("--runs", type=int, default=30, help="Runs per experimental condition.")
    parser.add_argument("--seed", type=int, default=SIMULATION["seed"], help="Base random seed.")
    parser.add_argument(
        "--output-dir", type=Path,
        default=Path(__file__).resolve().parent.parent / "output",
        help="Output root; each flood case is saved in its own subdirectory.",
    )
    args = parser.parse_args()
    if args.runs < 1:
        parser.error("--runs must be at least 1")
    return args


def run_conditions(args):
    """Run cases sequentially and restore the shared configuration even on failure."""
    original_config = deepcopy(SIMULATION)
    baseline_inflow = original_config["flood_inflow_m3_per_minute"]
    if baseline_inflow <= 0:
        raise ValueError("The configured baseline flood inflow must be positive.")
    if args.flood_condition == "additional":
        conditions = ["slower", "faster"]
    elif args.flood_condition == "all":
        conditions = list(FLOOD_CONDITIONS)
    else:
        conditions = [args.flood_condition]
    strategies = list(PROFILE_STRATEGIES) if args.scenario == "all" else [args.scenario]
    configurations = list(PROFILE_CONFIGS) if args.profile_config == "all" else [args.profile_config]
    sensitivities = (
        list(RESCUE_SENSITIVITY_CONFIGS)
        if args.rescue_sensitivity == "all" else [args.rescue_sensitivity]
    )

    try:
        for condition in conditions:
            # Mutate in place: simulator modules share this dictionary by import.
            SIMULATION.clear()
            SIMULATION.update(deepcopy(original_config))
            multiplier = FLOOD_CONDITIONS[condition]
            SIMULATION["flood_inflow_m3_per_minute"] = baseline_inflow * multiplier
            SIMULATION["flood_condition"] = condition
            SIMULATION["flood_inflow_multiplier"] = multiplier
            SIMULATION["baseline_flood_inflow_m3_per_minute"] = baseline_inflow
            results = []
            groups = {}
            for strategy in strategies:
                for configuration in configurations:
                    for sensitivity in sensitivities:
                        condition_results = []
                        for run_index in range(args.runs):
                            # Match seeds across flood cases, policies, and request rates.
                            result = run_simulation(
                                strategy, configuration, args.seed + run_index, sensitivity
                            )
                            result["flood_condition"] = condition
                            result["flood_inflow_multiplier"] = multiplier
                            results.append(result)
                            condition_results.append(result)
                        groups[f"{strategy}/{configuration}/{sensitivity}"] = condition_results

            output_dir = args.output_dir / f"{condition}_flood"
            # Write before selecting the next flood case, while its config is active.
            write_outputs(results, output_dir)
            print(json.dumps({
                "flood_condition": condition,
                "flood_inflow_multiplier": multiplier,
                "flood_inflow_m3_per_minute": SIMULATION["flood_inflow_m3_per_minute"],
                "run_count": len(results),
                "output_dir": str(output_dir.resolve()),
                "aggregates": {key: aggregate_runs(values) for key, values in groups.items()},
            }, indent=2))
    finally:
        SIMULATION.clear()
        SIMULATION.update(original_config)


if __name__ == "__main__":
    run_conditions(parse_args())
