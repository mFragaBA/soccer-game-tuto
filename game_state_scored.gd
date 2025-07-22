class_name GameStateScored
extends GameState

const DURATION_CELEBRATION := 3000

var time_since_celebration := Time.get_ticks_msec()

func _enter_tree() -> void:
	var team_scoring_index = 1 if state_data.team_scored_on == game_manager.get_home_country() else 0
	game_manager.score[team_scoring_index] += 1

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_since_celebration > DURATION_CELEBRATION:
		transition_state(GameManager.State.RESET, state_data)
