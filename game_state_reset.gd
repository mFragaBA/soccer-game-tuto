class_name GameStateReset
extends GameState

var remaining_players_to_reset := 12

func _enter_tree() -> void:
	remaining_players_to_reset = 12
	GameEvents.player_reset_complete.connect(on_player_reset_complete.bind())
	GameEvents.team_reset.emit()

func on_player_reset_complete() -> void:
	remaining_players_to_reset -= 1
	if remaining_players_to_reset == 0:
		transition_state(GameManager.State.KICKOFF)
