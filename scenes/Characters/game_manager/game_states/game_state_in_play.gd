class_name GameStateInPlay
extends GameState

func _enter_tree() -> void:
	GameEvents.team_scored.connect(on_team_scored.bind())

func _process(delta: float) -> void:
	game_manager.time_left -= delta
	if game_manager.is_time_up():
		if game_manager.current_match.is_tied():
			transition_state(GameManager.State.OVERTIME)
		else:
			transition_state(GameManager.State.GAMEOVER)
	
func on_team_scored(team_scored_on: String) -> void:
	var data := GameStateData.new()
	data.team_scored_on = team_scored_on
	transition_state(GameManager.State.SCORED, data)
