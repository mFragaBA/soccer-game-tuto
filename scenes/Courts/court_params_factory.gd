class_name CourtParamsFactory
extends Object

enum CourtType { WET_GRASS, GRASS, CONCRETE, HARD_WOOD }

var court_params : Dictionary

func _init() -> void:
	court_params = {
		CourtType.GRASS: CourtParameters.new()
			.set_friction(0.6)
			.set_bounciness(0.5),
		CourtType.WET_GRASS: CourtParameters.new()
			.set_friction(0.4)
			.set_bounciness(0.3),
		CourtType.CONCRETE: CourtParameters.new()
			.set_friction(0.5)
			.set_bounciness(0.75),
		CourtType.HARD_WOOD: CourtParameters.new()
			.set_friction(0.3)
			.set_bounciness(0.85)
	}

func get_court_params(court_type: CourtType) -> CourtParameters:
	assert(court_params.has(court_type), "court doesn't exit")
	
	return court_params[court_type]
