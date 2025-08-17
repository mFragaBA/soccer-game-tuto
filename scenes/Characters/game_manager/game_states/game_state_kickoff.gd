class_name GameStateKickoff
extends GameState

var valid_control_schemes := []

func _enter_tree() -> void:
	var team_starting := state_data.team_scored_on
	
	if team_starting.is_empty():
		team_starting = game_manager.current_match.team_home
	
	if team_starting == game_manager.player_setup[0]:
		valid_control_schemes.append(Player.ControlScheme.P1)
		
	if team_starting == game_manager.player_setup[1]:
		valid_control_schemes.append(Player.ControlScheme.P2)
		
	# If the cpu will kick off, still allow player one to have control over kickoff
	if valid_control_schemes.size() == 0:
		valid_control_schemes.append(Player.ControlScheme.P1)
		
func _process(_delta: float) -> void:
	for control_scheme : Player.ControlScheme in valid_control_schemes:
		if KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.PASS):
			GameEvents.kickoff_started.emit()
			SoundPlayer.play(SoundPlayer.Sound.WHISTLE)
			transition_state(GameManager.State.IN_PLAY)
