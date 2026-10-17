import argparse
import csv
import json
import math
from pathlib import Path

import simpy

from communication import MessageBroker
from config import (
    COST_MODEL,
    PROFILE_CONFIGS,
    PROFILE_MEMBERSHIP_POLICY,
    PROFILE_STRATEGIES,
    RESCUE_SENSITIVITY_CONFIGS,
    SIMULATION,
    TASK_SUCCESS_PROBABILITY_BY_HEALTH,
    UNIT_CONFIG,
)
from coordinator import SoSCoordinator
from cost_model import derive_activity_quantities, estimate_cost
from digital_twin import DigitalTwin, create_machine
from environment import FloodEnvironment
from physical_units import PhysicalUnit
from scenarios import apply_connectivity_scenario, run_twins


def run_simulation(strategy, profile_configuration, seed, rescue_sensitivity="boat_emphasis"):
    SIMULATION["profile_strategy"] = strategy
    SIMULATION["profile_configuration"] = profile_configuration
    rescue_parameters = RESCUE_SENSITIVITY_CONFIGS[rescue_sensitivity]
    SIMULATION["rescue_area_penalty"] = rescue_parameters["rescue_area_penalty"]
    SIMULATION["rescue_capacity_per_boat_step"] = rescue_parameters[
        "rescue_capacity_per_boat_step"
    ]
    env = simpy.Environment()
    flood = FloodEnvironment(env)
    broker = MessageBroker(
        env,
        SIMULATION["message_latency"],
        SIMULATION["message_loss_probability"],
        seed=seed,
    )
    twins = [
        DigitalTwin(
            name,
            PhysicalUnit(name, flood),
            broker,
            create_machine("Reactive"),
            "Reactive",
            # Unused reserve boats start in the generated Disengaged state.
            joined_at_start=(
                UNIT_CONFIG[name].get("role") != "reserve"
                and bool(UNIT_CONFIG[name].get("active_at_start", True))
            ),
            seed=seed,
        )
        for name in UNIT_CONFIG
    ]
    coordinator = SoSCoordinator(env, broker, flood, twins, seed=seed)
    env.process(flood.run())
    env.process(run_twins(env, twins))
    env.process(apply_connectivity_scenario(env, twins))
    env.process(coordinator.run())
    env.run(until=SIMULATION["duration"])
    # Collect local twin logs through the final simulation timestamp, including
    # task outcomes that were produced on the last step but not yet observed.
    coordinator.observe_state_changes()

    target = math.ceil(flood.total_victims * SIMULATION["mission_success_fraction"])
    success = flood.victims_rescued_before_deadline >= target
    metrics = coordinator.metrics()
    activity_quantities = derive_activity_quantities(broker.log, metrics, SIMULATION["duration"])
    costs = estimate_cost(activity_quantities, SIMULATION["duration"], COST_MODEL)
    return {
        "scenario": strategy,
        "scenario_name": PROFILE_STRATEGIES[strategy],
        "profile_configuration": profile_configuration,
        "profile_configuration_parameters": PROFILE_CONFIGS[profile_configuration],
        "rescue_sensitivity": rescue_sensitivity,
        "rescue_area_penalty": SIMULATION["rescue_area_penalty"],
        "rescue_capacity_per_boat_step": SIMULATION["rescue_capacity_per_boat_step"],
        "seed": seed,
        "duration": SIMULATION["duration"],
        "mission_success": success,
        "mission_success_target": target,
        "mission_success_fraction": SIMULATION["mission_success_fraction"],
        "victims_created": flood.total_victims,
        "victims_rescued": flood.victims_rescued,
        "victims_rescued_before_deadline": flood.victims_rescued_before_deadline,
        "victims_waiting": flood.victims_waiting,
        "victims_expired": flood.victims_expired,
        "final_victims_per_area": flood.victims_per_area,
        "final_water_level": flood.water_level,
        "final_flooded_area": flood.flooded_area,
        "pumped_water": flood.pumped_water,
        "profiles": {t.name: t.profile for t in twins},
        "health": {t.name: t.health_state() for t in twins},
        "belonging": {t.name: t.belonging_state() for t in twins},
        "roles": {t.name: t.unit.role for t in twins},
        "activity_quantities": activity_quantities,
        "costs": costs,
        **metrics,
        "state_transitions": {
            t.name: [entry for entry in t.log if entry.get("event") == "state_transition"]
            for t in twins
        },
        "coordinator_events": [
            event
            for event in coordinator.events
            if event["event"]
            not in {"telemetry_received", "task_result"}
        ],
        "flood_history": flood.history,
    }


def aggregate_runs(results):
    run_count = len(results)
    return {
        "runs": run_count,
        "successes": sum(result["mission_success"] for result in results),
        "success_rate": sum(result["mission_success"] for result in results) / run_count,
        "mean_victims_rescued_before_deadline": sum(
            result["victims_rescued_before_deadline"] for result in results
        )
        / run_count,
        "mean_peak_attached_dts": sum(result["peak_attached_dts"] for result in results)
        / run_count,
        "mean_peak_constellation_dts": sum(
            result["peak_constellation_dts"] for result in results
        )
        / run_count,
        "mean_dt_time": sum(result["dt_time"] for result in results) / run_count,
        "mean_active_dt_time": sum(result["active_dt_time"] for result in results) / run_count,
        "mean_active_dt_time_by_asset": {
            asset: sum(result["active_dt_time_by_asset"].get(asset, 0.0) for result in results)
            / run_count
            for asset in sorted(
                {asset for result in results for asset in result["active_dt_time_by_asset"]}
            )
        },
        "mean_pumping_station_active_time": sum(
            result["pumping_station_active_time"] for result in results
        ) / run_count,
        "mean_pumping_station_service_time": sum(
            result["pumping_station_service_time"] for result in results
        ) / run_count,
        "mean_pumped_water": sum(result["pumped_water"] for result in results) / run_count,
        "mean_pumping_station_health_communication_unavailable_time": sum(
            result["pumping_station_health_communication_unavailable_time"]
            for result in results
        ) / run_count,
        "mean_backup_activations": sum(result["backup_activations"] for result in results)
        / run_count,
        "mean_backup_requests": sum(result["backup_requests"] for result in results)
        / run_count,
        "mean_backup_rescue_time": sum(result["backup_rescue_time"] for result in results)
        / run_count,
        "mean_backup_standby_time": sum(result["backup_standby_time"] for result in results)
        / run_count,
        "mean_repair_requests": sum(result["repair_requests"] for result in results)
        / run_count,
        "mean_repair_time": sum(result["repair_time"] for result in results) / run_count,
        "mean_repairs_completed": sum(result["repairs_completed"] for result in results)
        / run_count,
        "mean_cost_low": sum(result["costs"]["total_low"] for result in results) / run_count,
        "mean_cost_base": sum(result["costs"]["total_base"] for result in results) / run_count,
        "mean_cost_high": sum(result["costs"]["total_high"] for result in results) / run_count,
        "mean_cost_by_category_base": {
            category: sum(result["costs"]["by_category"]["base"].get(category, 0.0) for result in results)
            / run_count
            for category in sorted(
                {
                    category
                    for result in results
                    for category in result["costs"]["by_category"]["base"]
                }
            )
        },
        "mean_sos_request_counts": {
            event: sum(result["sos_request_counts"].get(event, 0) for result in results) / run_count
            for event in sorted(
                {event for result in results for event in result["sos_request_counts"]}
            )
        },
        "mean_join_request_counts": {
            event: sum(result["join_request_counts"].get(event, 0) for result in results) / run_count
            for event in sorted(
                {event for result in results for event in result["join_request_counts"]}
            )
        },
        "mean_health_lifecycle_counts": {
            event: sum(result["health_lifecycle_counts"].get(event, 0) for result in results) / run_count
            for event in sorted(
                {event for result in results for event in result["health_lifecycle_counts"]}
            )
        },
        "mean_task_outcome_counts": {
            outcome: sum(result["task_outcome_counts"].get(outcome, 0) for result in results)
            / run_count
            for outcome in sorted(
                {outcome for result in results for outcome in result["task_outcome_counts"]}
            )
        },
        "mean_dt_time_by_asset": {
            asset: sum(result["dt_time_by_asset"].get(asset, 0.0) for result in results)
            / run_count
            for asset in sorted({asset for result in results for asset in result["dt_time_by_asset"]})
        },
    }


def write_outputs(results, output_dir):
    output_dir.mkdir(parents=True, exist_ok=True)
    by_condition = {}
    for result in results:
        key = (
            result["scenario"],
            result["profile_configuration"],
            result["rescue_sensitivity"],
        )
        by_condition.setdefault(key, []).append(result)

    summary = {
        "experiment": {
            "profile_configurations": PROFILE_CONFIGS,
            "profile_membership_policy": PROFILE_MEMBERSHIP_POLICY,
            "task_success_probability_by_health": TASK_SUCCESS_PROBABILITY_BY_HEALTH,
            "cost_model": COST_MODEL,
            "simulation_config": {
                **SIMULATION,
                "profile_strategy": "per-run",
                "profile_configuration": "per-run",
                "rescue_sensitivity": "per-run",
                "rescue_area_penalty": "per-run",
                "rescue_capacity_per_boat_step": "per-run",
            },
            "rescue_sensitivity_configurations": RESCUE_SENSITIVITY_CONFIGS,
            "conditions": [
                {
                    "scenario": scenario,
                    "profile_configuration": configuration,
                    "rescue_sensitivity": sensitivity,
                }
                for scenario, configuration, sensitivity in by_condition
            ],
        },
        "aggregates": {
            f"{scenario}/{configuration}/{sensitivity}": aggregate_runs(condition_results)
            for (scenario, configuration, sensitivity), condition_results in by_condition.items()
        },
        "runs": [
            {key: value for key, value in result.items() if key != "flood_history"}
            for result in results
        ],
    }
    with (output_dir / "simulation_summary.json").open("w", encoding="utf-8") as file:
        json.dump(summary, file, indent=2)

    run_fields = [
        "scenario",
        "scenario_name",
        "profile_configuration",
        "rescue_sensitivity",
        "rescue_area_penalty",
        "rescue_capacity_per_boat_step",
        "seed",
        "mission_success",
        "mission_success_target",
        "victims_created",
        "victims_rescued_before_deadline",
        "victims_expired",
        "peak_attached_dts",
        "peak_constellation_dts",
        "dt_time",
        "active_dt_time",
        "active_dt_time_boat",
        "active_dt_time_drone",
        "active_dt_time_pump",
        "pumping_station_active_time",
        "pumping_station_service_time",
        "pumping_station_health_communication_unavailable_time",
        "backup_requests",
        "backup_activations",
        "backup_rescue_time",
        "backup_standby_time",
        "cost_total_low",
        "cost_total_base",
        "cost_total_high",
        "cost_IT_infrastructure_base",
        "cost_Resources_base",
        "cost_Data_activities_base",
        "cost_Investment_base",
        "sos_requests_generated",
        "sos_requests_profile_denied",
        "sos_requests_capacity_deferred",
        "sos_requests_submitted_to_bm",
        "sos_requests_completed",
        "join_requests_generated",
        "join_requests_profile_denied",
        "join_requests_submitted_to_bm",
        "join_requests_machine_rejected",
        "join_requests_completed",
        "health_lifecycle_eligible_departures",
        "health_lifecycle_repairs_ready",
        "health_lifecycle_replacement_requests",
        "health_lifecycle_replacement_activations",
        "health_lifecycle_replacement_shortfalls",
        "health_lifecycle_return_requests",
        "health_lifecycle_return_retries",
        "health_lifecycle_returned_to_disengaged",
        "health_lifecycle_return_delayed",
        "tasks_attempted",
        "tasks_succeeded",
        "tasks_failed_health",
        "tasks_failed_physical",
        "tasks_failed_other",
        "repair_time",
        "repair_requests",
        "repairs_completed",
        "final_water_level",
        "final_flooded_area",
        "final_victims_per_area",
        "pumped_water",
    ]
    with (output_dir / "simulation_runs.csv").open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=run_fields)
        writer.writeheader()
        for result in results:
            row = {field: result.get(field) for field in run_fields}
            row.update(
                {
                    "cost_total_low": result["costs"]["total_low"],
                    "cost_total_base": result["costs"]["total_base"],
                    "cost_total_high": result["costs"]["total_high"],
                    "cost_IT_infrastructure_base": result["costs"]["by_category"]["base"].get("IT infrastructure", 0.0),
                    "cost_Resources_base": result["costs"]["by_category"]["base"].get("Resources", 0.0),
                    "cost_Data_activities_base": result["costs"]["by_category"]["base"].get("Data activities", 0.0),
                    "cost_Investment_base": result["costs"]["by_category"]["base"].get("Investment", 0.0),
                    **{
                        f"active_dt_time_{asset}": result["active_dt_time_by_asset"].get(asset, 0.0)
                        for asset in ("boat", "drone", "pump")
                    },
                    **{
                        f"sos_requests_{key}": value
                        for key, value in result["sos_request_counts"].items()
                    },
                    **{
                        f"join_requests_{key}": value
                        for key, value in result["join_request_counts"].items()
                    },
                    **{
                        f"health_lifecycle_{key}": value
                        for key, value in result["health_lifecycle_counts"].items()
                    },
                    **{
                        f"tasks_{key}": value
                        for key, value in result["task_outcome_counts"].items()
                    },
                }
            )
            writer.writerow(row)

    history_fields = [
        "scenario",
        "profile_configuration",
        "seed",
        "time",
        "rescue_sensitivity",
        "rescue_area_penalty",
        "rescue_capacity_per_boat_step",
        "water_level",
        "flooded_area",
        "victims_waiting",
        "victims_rescued",
        "victims_rescued_before_deadline",
        "victims_expired",
        "total_victims",
        "victims_per_area",
    ]
    with (output_dir / "flood_history.csv").open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=history_fields)
        writer.writeheader()
        for result in results:
            for row in result["flood_history"]:
                writer.writerow(
                    {
                        "scenario": result["scenario"],
                        "profile_configuration": result["profile_configuration"],
                        "rescue_sensitivity": result["rescue_sensitivity"],
                        "rescue_area_penalty": result["rescue_area_penalty"],
                        "rescue_capacity_per_boat_step": result[
                            "rescue_capacity_per_boat_step"
                        ],
                        "seed": result["seed"],
                        **row,
                    }
                )


def parse_args():
    parser = argparse.ArgumentParser(description="Run the flood-response DT SoS experiment.")
    parser.add_argument(
        "--scenario",
        choices=["all", *PROFILE_STRATEGIES],
        default="all",
        help="Profile assignment strategy to run (default: all three).",
    )
    parser.add_argument(
        "--profile-config",
        choices=["all", *PROFILE_CONFIGS],
        default="all",
        help="Profile departure-rate configuration to run (default: all configurations).",
    )
    parser.add_argument(
        "--rescue-sensitivity",
        choices=["all", *RESCUE_SENSITIVITY_CONFIGS],
        default="boat_emphasis",
        help=(
            "Rescue-factor condition to run; use 'all' for the matched 2x2 "
            "pump-effect/boat-capacity sensitivity sweep (default: boat_emphasis)."
        ),
    )
    parser.add_argument("--runs", type=int, default=30, help="Repetitions per strategy/configuration condition.")
    parser.add_argument("--seed", type=int, default=SIMULATION["seed"], help="Base random seed.")
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path(__file__).resolve().parent / "output",
        help="Directory for experiment outputs.",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    if args.runs < 1:
        raise ValueError("--runs must be at least 1")
    strategies = list(PROFILE_STRATEGIES) if args.scenario == "all" else [args.scenario]
    configurations = list(PROFILE_CONFIGS) if args.profile_config == "all" else [args.profile_config]
    rescue_sensitivities = (
        list(RESCUE_SENSITIVITY_CONFIGS)
        if args.rescue_sensitivity == "all"
        else [args.rescue_sensitivity]
    )
    results = []
    for strategy in strategies:
        for configuration in configurations:
            for rescue_sensitivity in rescue_sensitivities:
                for run_index in range(args.runs):
                    # Match seeds across all profile and rescue-factor conditions.
                    seed = args.seed + run_index
                    results.append(
                        run_simulation(strategy, configuration, seed, rescue_sensitivity)
                    )
    write_outputs(results, args.output_dir)
    print(
        json.dumps(
            {
                f"{strategy}/{configuration}/{sensitivity}": aggregate_runs(
                    [
                        r
                        for r in results
                        if r["scenario"] == strategy
                        and r["profile_configuration"] == configuration
                        and r["rescue_sensitivity"] == sensitivity
                    ]
                )
                for strategy in strategies
                for configuration in configurations
                for sensitivity in rescue_sensitivities
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
