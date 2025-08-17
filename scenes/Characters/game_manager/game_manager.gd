extends Node

# 2 minutes
const GAME_DURATION_SECONDS := 2 * 60
const IMPACT_PAUSE_DURATION := 80 

enum State { IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEOVER }

var current_state : GameState = null
var game_state_factory := GameStateFactory.new()

var current_match : Match = null
var time_left : float
var time_since_paused := Time.get_ticks_msec()

var player_setup : Array[String] = [ "BOCA", "" ]

func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	time_left = GAME_DURATION_SECONDS
	GameEvents.impact_received.connect(on_impact_received.bind())
	
func _process(_delta: float) -> void:
	if get_tree().paused and Time.get_ticks_msec() - time_since_paused > IMPACT_PAUSE_DURATION:
		get_tree().paused = false

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
	
func is_time_up() -> bool:
	return time_left <= 0
	
func get_winning_country() -> String:
	assert(not current_match.is_tied())
	return current_match.winner
	
func start_game() -> void:
	switch_state(State.KICKOFF)

func increase_score(team_scored_on: String) -> void:
	current_match.increase_score(team_scored_on)
	GameEvents.score_changed.emit()
	
func on_impact_received(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		time_since_paused = Time.get_ticks_msec()
		get_tree().paused = true
