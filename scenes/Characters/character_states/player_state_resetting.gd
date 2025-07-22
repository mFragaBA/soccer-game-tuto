class_name PlayerStateResetting
extends PlayerState

var has_arrived := false

func _process(_delta: float) -> void:
	if not has_arrived:
		var direction := player.position.direction_to(state_data.reset_position)
		if player.position.distance_squared_to(state_data.reset_position) < 2:
			has_arrived = true
			player.face_towards_target_goal()
			player.velocity = Vector2.ZERO
			GameEvents.player_reset_complete.emit()
		else:
			player.velocity = direction * player.speed
			
		player.set_movement_animation()
		player.set_heading()
		
