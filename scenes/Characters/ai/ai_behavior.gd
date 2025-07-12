class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY := 200

var player : Player = null
var ball : Ball = null
var opponent_detection_area : Area2D = null
var time_since_last_ai_tick := Time.get_ticks_msec()

func ready() -> void:
	# add random value so AIs tick at different times
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, AI_TICK_FREQUENCY)

func setup(context_player: Player, context_ball: Ball, context_opponent_detection_area: Area2D) -> void:
	player = context_player
	ball = context_ball
	opponent_detection_area = context_opponent_detection_area
	
func process_ai() -> void:
	if (Time.get_ticks_msec() - time_since_last_ai_tick) > AI_TICK_FREQUENCY:
		time_since_last_ai_tick = Time.get_ticks_msec()
		perform_ai_movement()
		perform_ai_decisions()

func perform_ai_movement():
	pass
	
func perform_ai_decisions():
	pass

func get_bicircular_weight(position: Vector2, target_position: Vector2, inner_circle_radius: float, inner_circle_weight: float, outer_circle_radius: float, outer_circle_weight: float) -> float:
	var distance_to_center = position.distance_to(target_position)
	
	if distance_to_center > outer_circle_radius:
		return outer_circle_weight
	elif distance_to_center < inner_circle_radius:
		return inner_circle_weight
	else:
		var distance_to_inner_radius = distance_to_center - inner_circle_radius
		var close_range_distance = outer_circle_radius - inner_circle_radius
		# How far we are towards the inner circle (thought as % of full distance between both radiuses)
		return lerpf(inner_circle_weight, outer_circle_weight, distance_to_inner_radius / close_range_distance)

func is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != self and ball.carrier.country == player.country

func is_ball_possessed_by_opponent() -> bool:
	return ball.carrier != null and ball.carrier.country != player.country

func has_opponents_nearby() -> bool:
	var players := opponent_detection_area.get_overlapping_bodies()
	return players.filter(func(p: Player): return p.country != player.country).size() > 0

func face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.heading *= -1
