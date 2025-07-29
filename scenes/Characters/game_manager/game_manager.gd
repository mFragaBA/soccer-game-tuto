extends Node

# 2 minutes
const GAME_DURATION_SECONDS := 2 * 60 

enum State { IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEOVER }

var current_state : GameState = null
var game_state_factory := GameStateFactory.new()

var countries : Array[String] = [ "BOCA", "RIVER" ]
var score : Array[int] = [ 0, 0 ]
var time_left : float

var player_setup : Array[String] = [ "BOCA", "" ]

func _ready() -> void:
	time_left = GAME_DURATION_SECONDS
	switch_state(State.KICKOFF)

func get_home_country() -> String:
	return countries[0]
	
func get_away_country() -> String:
	return countries[1]
	
func switch_state(state: State, game_state_data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = game_state_factory.get_fresh_state(state)
	current_state.setup(self, game_state_data)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "GameManagerStateMachine: " + str(state)

	# doesn't interfere with removing the pre-existing state
	call_deferred("add_child", current_state)	

func is_coop() -> bool:
	return player_setup[0] == player_setup[1]
	
func is_single_player() -> bool:
	return player_setup[1] == ""
