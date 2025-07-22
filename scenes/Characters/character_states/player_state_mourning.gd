class_name PlayerStateMourning
extends PlayerState

func _enter_tree() -> void:
	animation_player.play("mourn")
	player.velocity = Vector2.ZERO
	GameEvents.team_reset.connect(on_team_reset.bind())
	
func on_team_reset() -> void:
	var data := PlayerStateData.new()
	data.reset_position = player.kickoff_position
	transition_state(Player.State.RESETTING, data)
