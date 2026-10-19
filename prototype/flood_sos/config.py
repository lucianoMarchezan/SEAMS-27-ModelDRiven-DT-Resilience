PROFILE_LEVELS = {"Reactive": 0, "Proactive": 1, "Controlled": 2, "Adaptive": 3}

# Baseline per-attempt task success probabilities, linearly interpolated
# between the Ideal (1.0) and Failed (0.0) health endpoints.
TASK_SUCCESS_PROBABILITY_BY_HEALTH = {
    "Ideal": 1.0,
    "Defective": 5.0 / 6.0,
    "Faulty": 4.0 / 6.0,
    "Erroneous": 3.0 / 6.0,
    "Malfunctioning": 2.0 / 6.0,
    "Degraded": 1.0 / 6.0,
    "Failed": 0.0,
}
HEALTH_IMPAIRED_STATES = frozenset(
    {"Defective", "Faulty", "Erroneous", "Malfunctioning", "Degraded", "Failed"}
)

PROFILE_STRATEGIES = {
    "low_only": "Static permissive",
    "high_only": "Static restrictive",
    "mixed": "Dynamic",
}

# Rescue capacity is measured in victims per boat per simulated minute.
# Pump-effect coefficients multiply flooded area measured in hectares.
RESCUE_SENSITIVITY_CONFIGS = {
    "reference": {
        "rescue_area_penalty": 0.12,
        "rescue_capacity_per_boat_minute": 2.0,
    },
    "reduced_pump_effect": {
        "rescue_area_penalty": 0.04,
        "rescue_capacity_per_boat_minute": 2.0,
    },
    "increased_boat_capacity": {
        "rescue_area_penalty": 0.12,
        "rescue_capacity_per_boat_minute": 3.0,
    },
    "boat_emphasis": {
        "rescue_area_penalty": 0.04,
        "rescue_capacity_per_boat_minute": 3.0,
    },
}

# These are Poisson request rates per simulated minute, not guaranteed
# departures. Profile-specific request handling is configured separately below.
PROFILE_CONFIGS = {
    "baseline": {
        "Reactive": {"departure_rate": 0.08},
        "Proactive": {"departure_rate": 0.08},
        "Controlled": {"departure_rate": 0.08},
        "Adaptive": {"departure_rate": 0.08},
    },
    "reduced_departure": {
        "Reactive": {"departure_rate": 0.04},
        "Proactive": {"departure_rate": 0.04},
        "Controlled": {"departure_rate": 0.04},
        "Adaptive": {"departure_rate": 0.04},
    },
    "increased_departure": {
        "Reactive": {"departure_rate": 0.16},
        "Proactive": {"departure_rate": 0.16},
        "Controlled": {"departure_rate": 0.16},
        "Adaptive": {"departure_rate": 0.16},
    },
}

# The profile response affects voluntary SoS requests, not hm-driven health
# transitions. Processing work is an activity driver for the ABC estimate.
PROFILE_MEMBERSHIP_POLICY = {
    "Reactive": {"leave_acceptance": 0.90, "join_acceptance": 0.60, "processing_work_per_minute": 1.0},
    "Proactive": {"leave_acceptance": 0.65, "join_acceptance": 0.75, "processing_work_per_minute": 1.2},
    "Controlled": {"leave_acceptance": 0.40, "join_acceptance": 0.90, "processing_work_per_minute": 1.5},
    "Adaptive": {"leave_acceptance": 0.20, "join_acceptance": 0.95, "processing_work_per_minute": 1.8},
}

UNIT_CONFIG = {
    "UAV": {
        "asset_type": "drone",
        "role": "aerial_monitoring",
        "profile_role": "drone",
        "battery": 100.0,
        "speed": 12.0,
    },
    "RescueBoat": {
        "asset_type": "boat",
        "role": "rescue",
        "profile_role": "rescue_boat",
        "active_at_start": True,
        "battery": 100.0,
        "speed": 5.0,
    },
    "MonitoringBoat": {
        "asset_type": "boat",
        "role": "monitoring",
        "profile_role": "boat",
        "active_at_start": True,
        "battery": 100.0,
        "speed": 4.0,
    },
    "ReserveBoat1": {
        "asset_type": "boat",
        "role": "reserve",
        "profile_role": "boat",
        "active_at_start": False,
        "battery": 100.0,
        "speed": 4.5,
    },
    "ReserveBoat2": {
        "asset_type": "boat",
        "role": "reserve",
        "profile_role": "boat",
        "active_at_start": False,
        "battery": 100.0,
        "speed": 4.5,
    },
    "ReserveBoat3": {
        "asset_type": "boat",
        "role": "reserve",
        "profile_role": "boat",
        "active_at_start": False,
        "battery": 100.0,
        "speed": 4.5,
    },
    "ReserveBoat4": {
        "asset_type": "boat",
        "role": "reserve",
        "profile_role": "boat",
        "active_at_start": False,
        "battery": 100.0,
        "speed": 4.5,
    },
    "ReserveBoat5": {
        "asset_type": "boat",
        "role": "reserve",
        "profile_role": "boat",
        "active_at_start": False,
        "battery": 100.0,
        "speed": 4.5,
    },
    "ReserveBoat6": {
        "asset_type": "boat",
        "role": "reserve",
        "profile_role": "boat",
        "active_at_start": False,
        "battery": 100.0,
        "speed": 4.5,
    },
    "PumpingStation": {
        "asset_type": "pump",
        "role": "water_removal",
        "profile_role": "pump",
        "battery": 100.0,
        "speed": 0.0,
    },
}

MIXED_PROFILE_THRESHOLDS = {
    "proactive": 0.5,
    "controlled": 1.0,
    "adaptive": 1.8,
}

SIMULATION = {
    # SimPy uses a virtual seconds clock; the default decision/environment
    # interval is one simulated minute, independent of wall-clock runtime.
    "time_unit": "seconds",
    "metric_time_unit": "minutes",
    "duration": 3600.0,
    "step": 60.0,
    "seed": 7,
    "profile_strategy": "mixed",
    "profile_configuration": "baseline",
    # Synthetic flood assumptions: water storage is converted to depth using
    # a stage-area relation; these are not site-calibrated measurements.
    "initial_water_level": 0.2,
    "storage_area_base_m2": 50000.0,
    "storage_area_expansion_m2_per_m": 15000.0,
    "flood_inflow_m3_per_minute": 3500.0,
    "pump_discharge_m3_per_minute": 300.0,
    # Common cohort of 240 victims, distributed across the 60-minute incident.
    "initial_victims": 10,
    "victim_arrival_waves": [
        {"time": 600.0, "count": 46},
        {"time": 1200.0, "count": 46},
        {"time": 1800.0, "count": 46},
        {"time": 2400.0, "count": 46},
        {"time": 3000.0, "count": 46},
    ],
    "victim_survival_time": 600.0,
    "mission_success_fraction": 1.0,
    "rescue_capacity_per_boat_minute": RESCUE_SENSITIVITY_CONFIGS["boat_emphasis"]["rescue_capacity_per_boat_minute"],
    "rescue_area_penalty": RESCUE_SENSITIVITY_CONFIGS["boat_emphasis"]["rescue_area_penalty"],
    "telemetry_interval": 60.0,
    "message_latency": 0.2,
    "message_loss_probability": 0.05,
    "boat_disconnect_time": 480.0,
    "boat_disconnect_duration": 180.0,
    "boat_water_ingress_start_time": 720.0,
    "boat_water_ingress_m_per_minute": 0.16,
    # Exposure and maintenance intervals use elapsed simulated seconds.
    "fault_water_level_threshold": 1.5,
    "fault_exposure_per_minute": 1.2,
    "fault_exposure_per_transition": 10.0,
    "repair_duration": 600.0,
    "join_retry_interval": 60.0,
    "health_return_retry_interval": 60.0,
    # Health communication availability affects telemetry/result reporting;
    # task success itself is sampled from TASK_SUCCESS_PROBABILITY_BY_HEALTH.
}

# Illustrative cost units and ranges for exercising the ABC cost pipeline.
# Replace these values with sourced rates before making monetary claims.
COST_MODEL = {
    "cost_unit": "illustrative cost units",
    "rate_basis": "Illustrative placeholder rates for demonstrating the ABC calculation; not market prices or values taken from the cited manufacturing study.",
    "shared_capex_total": 10000.0,
    "capex_allocation_missions": 100,
    "investment_opex_per_mission_minute": {"low": 0.5, "base": 1.0, "high": 2.0},
    "activities": {
        "data_gathering": {
            "category": "Data activities", "resource": "Equipment", "driver_unit": "telemetry samples",
            "rates": {"low": 0.01, "base": 0.02, "high": 0.04},
        },
        "data_interaction": {
            "category": "IT infrastructure", "resource": "Services", "driver_unit": "published messages",
            "rates": {"low": 0.002, "base": 0.005, "high": 0.01},
        },
        "data_storage": {
            "category": "IT infrastructure", "resource": "Services", "driver_unit": "MB-minutes",
            "rates": {"low": 0.0005, "base": 0.001, "high": 0.002},
        },
        "data_processing": {
            "category": "Resources", "resource": "Machine / software", "driver_unit": "weighted processing cycles",
            "rates": {"low": 0.01, "base": 0.02, "high": 0.04},
        },
        "data_servitization": {
            "category": "Data activities", "resource": "Services", "driver_unit": "DT-minutes",
            "rates": {"low": 0.05, "base": 0.1, "high": 0.2},
        },
        "data_maintenance": {
            "category": "Resources", "resource": "Personnel", "driver_unit": "repair minutes",
            "rates": {"low": 0.25, "base": 0.5, "high": 1.0},
        },
        "backup_deployment": {
            "category": "Resources", "resource": "Equipment and personnel",
            "driver_unit": "backup rescue minutes",
            "rates": {"low": 0.25, "base": 0.5, "high": 1.0},
        },
        "backup_standby": {
            "category": "Resources", "resource": "Available reserve equipment",
            "driver_unit": "available backup DT-minutes",
            "rates": {"low": 0.05, "base": 0.1, "high": 0.2},
        },
    },
}
