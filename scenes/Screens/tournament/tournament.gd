class_name Tournament

enum Stage { ROUND_OF_THIRTY_TWO, ROUND_OF_SIXTEEN, QUARTER_FINALS, SEMI_FINALS, FINAL, COMPLETE }
const NEXT_STAGE := {
	Stage.ROUND_OF_THIRTY_TWO: Stage.ROUND_OF_SIXTEEN,
	Stage.ROUND_OF_SIXTEEN: Stage.QUARTER_FINALS,
	Stage.QUARTER_FINALS: Stage.SEMI_FINALS,
	Stage.SEMI_FINALS: Stage.FINAL,
	Stage.FINAL: Stage.COMPLETE
}

# Added more rounds but for now default is starting at quarter finals
var current_stage: Stage = Stage.QUARTER_FINALS
const NUM_TEAMS_PER_STAGE := {
	Stage.ROUND_OF_THIRTY_TWO: 32,
	Stage.ROUND_OF_SIXTEEN: 16,
	Stage.QUARTER_FINALS: 8,
	Stage.SEMI_FINALS: 4,
	Stage.FINAL: 2,
}
var matches : Dictionary = {
	Stage.ROUND_OF_THIRTY_TWO: [],
	Stage.ROUND_OF_SIXTEEN: [],
	Stage.QUARTER_FINALS: [],
	Stage.SEMI_FINALS: [],
	Stage.FINAL: []
}
var winner := ""

func _init(playing_countries: Array[String]) -> void:
	assert(is_power_of_2(playing_countries.size()), "need an amount of players that is a power of 2 to make a tournament") 	
	assert(playing_countries.size() <= 32, "longer elimination tournaments not suppoerted")
	
	current_stage = NUM_TEAMS_PER_STAGE.find_key(playing_countries.size())
	print(current_stage)
	
	create_bracket(current_stage, playing_countries)
	
func create_bracket(stage: Stage, countries: Array[String]) -> void:
	for i in range(0, countries.size(), 2):
		matches[stage].append(Match.new(countries[i], countries[i+1]))

func advance_stage() -> void:
	assert(current_stage != Stage.COMPLETE, "can't advance stage in completed tournament")
	
	var next_stage_teams : Array[String] = []
	for stage_match in matches[current_stage]:
		stage_match.resolve()
		next_stage_teams.append(stage_match.winner)
		
	current_stage = NEXT_STAGE[current_stage]
	
	if current_stage == Stage.COMPLETE:
		winner = next_stage_teams[0]
	else:
		create_bracket(current_stage, next_stage_teams)	

func is_power_of_2(x: int) -> bool:
	return (x != 0) && ((x & (x - 1)) == 0);
