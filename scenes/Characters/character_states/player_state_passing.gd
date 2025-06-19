class_name PlayerStatePassing
extends PlayerState

func _enter_tree() -> void:
	animation_player.play("kick")
	player.velocity = Vector2.ZERO
	
func on_animation_complete() -> void:
	var pass_target := find_teammate_in_sight()
	print(pass_target)
		
	if pass_target == null:
		ball.pass_to(player.position + player.heading * player.speed)
	else:
		ball.pass_to(pass_target.position + pass_target.velocity)
		
	transition_state(Player.State.MOVING)
	
func find_teammate_in_sight() -> Player:
	var players_in_sight := teammate_detection_area.get_overlapping_bodies()
	var teammates_in_sight := players_in_sight.filter(
		func(p: Player): return p != player
	)

	teammates_in_sight.sort_custom(
		func(p1: Player, p2: Player): return p1.position.distance_squared_to(player.position) > p2.position.distance_squared_to(player.position)
	)
	
	if teammates_in_sight.size() > 0:
		return teammates_in_sight[0]
	else:
		return null
