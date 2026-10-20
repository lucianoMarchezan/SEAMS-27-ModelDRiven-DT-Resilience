from collections import defaultdict
import json


COST_LEVELS = ("low", "base", "high")


def derive_activity_quantities(broker_log, coordinator_metrics, duration):
    """Build auditable activity drivers from simulated events and time metrics."""
    duration_minutes = float(duration) / 60.0
    published = [event for event in broker_log if event.get("type") == "published"]
    telemetry = [event for event in published if event.get("topic") == "telemetry"]
    stored_mb_time = 0.0
    for event in telemetry:
        payload_bytes = len(
            json.dumps(event.get("payload", {}), separators=(",", ":"), default=str).encode("utf-8")
        )
        retention_time = max(
            0.0, duration_minutes - float(event.get("time", 0.0)) / 60.0
        )
        stored_mb_time += payload_bytes / 1_000_000 * retention_time

    return {
        "data_gathering": float(len(telemetry)),
        "data_interaction": float(len(published)),
        "data_storage": stored_mb_time,
        "data_processing": float(coordinator_metrics.get("processing_work", 0.0)),
        "data_servitization": float(coordinator_metrics.get("dt_time", 0.0)),
        # This is an attribution subset of service time, not an additional
        # activity; it must not be added again to the ABC total.
        "autonomy_restriction_time": float(
            coordinator_metrics.get("forced_retention_minutes", 0.0)
        ),
        "data_maintenance": float(coordinator_metrics.get("repair_time", 0.0)),
        "backup_deployment": float(coordinator_metrics.get("backup_rescue_time", 0.0)),
        "backup_standby": float(coordinator_metrics.get("backup_standby_time", 0.0)),
    }


def estimate_cost(activity_quantities, mission_duration, cost_model):
    """Allocate configured resource rates to ABC activities and cost categories."""
    activity_costs = {}
    category_costs = {
        level: defaultdict(float)
        for level in COST_LEVELS
    }

    for activity, definition in cost_model["activities"].items():
        quantity = float(activity_quantities.get(activity, 0.0))
        rates = definition["rates"]
        activity_costs[activity] = {
            "category": definition["category"],
            "resource": definition["resource"],
            "driver_unit": definition["driver_unit"],
            "quantity": quantity,
            "rate_low": rates["low"],
            "rate_base": rates["base"],
            "rate_high": rates["high"],
            "cost_low": quantity * rates["low"],
            "cost_base": quantity * rates["base"],
            "cost_high": quantity * rates["high"],
        }
        for level in COST_LEVELS:
            category_costs[level][definition["category"]] += quantity * rates[level]

    # Attribute the existing DT service-time cost to periods when a voluntary
    # departure was blocked. This is a non-additive breakdown of
    # data_servitization, so the overall ABC cost remains unchanged.
    service_rates = cost_model["activities"]["data_servitization"]["rates"]
    retained_minutes = float(activity_quantities.get("autonomy_restriction_time", 0.0))
    autonomy_restriction_cost = {
        "quantity_minutes": retained_minutes,
        "cost_low": retained_minutes * service_rates["low"],
        "cost_base": retained_minutes * service_rates["base"],
        "cost_high": retained_minutes * service_rates["high"],
        "included_in_total": True,
        "accounting": "non_additive_attribution_of_data_servitization_cost",
        "basis_activity": "data_servitization",
    }

    allocation_missions = max(1, cost_model["capex_allocation_missions"])
    capex_per_mission = cost_model["shared_capex_total"] / allocation_missions
    opex_rates = cost_model["investment_opex_per_mission_minute"]
    investment_cost = {}
    for level in COST_LEVELS:
        opex = (float(mission_duration) / 60.0) * opex_rates[level]
        investment_cost[level] = {
            "capex_allocated": capex_per_mission,
            "opex": opex,
            "total": capex_per_mission + opex,
        }
        category_costs[level]["Investment"] += capex_per_mission + opex

    category_costs = {
        level: {category: round(value, 6) for category, value in sorted(costs.items())}
        for level, costs in category_costs.items()
    }
    totals = {
        level: round(sum(category_costs[level].values()), 6)
        for level in COST_LEVELS
    }
    return {
        "cost_unit": cost_model["cost_unit"],
        "total_low": totals["low"],
        "total_base": totals["base"],
        "total_high": totals["high"],
        "by_category": category_costs,
        "by_activity": activity_costs,
        "autonomy_restriction_attribution": autonomy_restriction_cost,
        "investment": investment_cost,
        "assumptions": {
            "rate_basis": cost_model.get("rate_basis", "Unspecified; calibrate before interpreting as monetary cost."),
            "shared_capex_total": cost_model["shared_capex_total"],
            "capex_allocation_missions": allocation_missions,
            "investment_opex_per_mission_minute": opex_rates,
        },
    }
