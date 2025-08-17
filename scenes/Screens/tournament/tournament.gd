class_name Tournament

const NUM_TEAMS := 8

enum Stage { QUARTER_FINALS, SEMI_FINALS, FINAL, COMPLETE }
const NEXT_STAGE := {
	Stage.QUARTER_FINALS: Stage.SEMI_FINALS,
	Stage.SEMI_FINALS: Stage.FINAL,
	Stage.FINAL: Stage.COMPLETE
}

var current_stage: Stage = Stage.QUARTER_FINALS
var matches : Dictionary = {
	Stage.QUARTER_FINALS: [],
	Stage.SEMI_FINALS: [],
	Stage.FINAL: []
}
var winner := ""

func _init() -> void:
	var playable_countries : Array[String] = DataLoader.get_countries().slice(1)
	playable_countries.shuffle()
	
	var playing_countries := playable_countries.slice(0, NUM_TEAMS)
	create_bracket(Stage.QUARTER_FINALS, playing_countries)
	
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
