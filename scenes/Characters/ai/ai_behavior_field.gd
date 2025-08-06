class_name AIBehaviorField
extends AIBehavior

const SHOT_DISTANCE := 150
const SHOT_PROBABILITY := 0.3
const SPREAD_FACTOR := 0.8
const TACKLE_DISTANCE := 15
const TACKLE_PROBABILITY := 0.3
const PASS_PROBABILITY := 0.1

func perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	if player.has_ball():
		total_steering_force += get_carrier_steering_force()
	if is_ball_carried_by_teammate():
		total_steering_force += get_assist_formation_steering_force()
	else:
		total_steering_force += get_on_duty_steering_force()
		# if not the first one on duty
		if total_steering_force.length() > 1:
			if is_ball_possessed_by_opponent():
				total_steering_force += get_spawns_steering_force()
			if ball.carrier == null:
				total_steering_force += get_ball_proximity_steering_force()
				total_steering_force += get_density_around_ball_force()

	total_steering_force = total_steering_force.limit_length(1.0)
		
	player.velocity = total_steering_force * player.speed
	
func perform_ai_decisions() -> void:
	if is_ball_possessed_by_opponent() and player.position.distance_to(ball.position) < TACKLE_DISTANCE and randf() < TACKLE_PROBABILITY:
		player.switch_state(Player.State.TACKLING)
	if ball.carrier == player:
		var target = player.target_goal.get_center_target_position()
		var distance_to_target := player.position.distance_to(target)
		if distance_to_target < SHOT_DISTANCE and randf() < SHOT_PROBABILITY:
			# Force player to face target
			player.face_towards_target_goal()
			
			# Shoot ball
			var data := PlayerStateData.new()
			var shot_direction := player.position.direction_to(player.target_goal.get_random_target_position())
			data.shot_power = player.power
			data.shot_direction = shot_direction
			player.switch_state(Player.State.SHOOTING, data)
		elif randf() < PASS_PROBABILITY and has_opponents_nearby() and has_teammate_in_view():
			player.switch_state(Player.State.PASSING)

func get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)

func get_carrier_steering_force() -> Vector2:
	var target := player.target_goal.get_center_target_position()
	var direction := player.position.direction_to(target)
	var weight := get_bicircular_weight(player.position, target, 100, 0, 150, 1)
	return weight * direction
	
func get_assist_formation_steering_force() -> Vector2:
	var spawn_offset_from_carrier := player.spawn_position - ball.carrier.spawn_position
	var assist_destination := ball.carrier.position + SPREAD_FACTOR * spawn_offset_from_carrier
	var direction = player.position.direction_to(assist_destination)
	var weight := get_bicircular_weight(player.position, assist_destination, 30, 0.2, 60, 1)
	return weight * direction

func get_ball_proximity_steering_force() -> Vector2:
	var weight := get_bicircular_weight(player.position, ball.position, 50, 1, 120, 0)
	var direction := player.position.direction_to(ball.position)
	
	return weight * direction

func get_spawns_steering_force() -> Vector2:
	var weight := get_bicircular_weight(player.position, player.spawn_position, 30, 0, 100, 1)
	var direction := player.position.direction_to(player.spawn_position)
	
	return weight * direction
	
func get_density_around_ball_force() -> Vector2:
	var n_teammates_around_ball := ball.get_proximity_teammates_count(player.country)
	if n_teammates_around_ball == 0:
		return Vector2.ZERO
		
	# The more teammates close to the wall, the further we want to be pushed away (e.g 3 players around ball means the force is at 66% force)
	var weight := 1 - 1.0 / n_teammates_around_ball
	var direction := ball.position.direction_to(player.position)
	
	return weight * direction
	
func has_teammate_in_view() -> bool:
	var players_in_view := teammate_detection_area.get_overlapping_bodies()
	return players_in_view.any(func(p: Player): return p.country == player.country and p != player)
