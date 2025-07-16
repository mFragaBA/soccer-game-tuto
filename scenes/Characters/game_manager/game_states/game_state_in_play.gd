class_name GameStateInPlay
extends GameState

func _enter_tree() -> void:
	GameEvents.team_scored.connect(on_team_scored.bind())

func _process(delta: float) -> void:
	game_manager.time_left -= delta
	if game_manager.time_left <= 0 and game_manager.score[0] == game_manager.score[1]:
		transition_state(GameManager.State.OVERTIME)
	elif game_manager.time_left <= 0:
		transition_state(GameManager.State.GAMEOVER)
	
func on_team_scored(team_scored_on: String) -> void:
	var data := GameStateData.new()
	data.team_scored_on = team_scored_on
	transition_state(GameManager.State.SCORED, data)
