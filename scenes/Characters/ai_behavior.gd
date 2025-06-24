class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY := 200

var player : Player = null
var ball : Ball = null
var time_since_last_ai_tick := Time.get_ticks_msec()

func ready() -> void:
	# add random value so AIs tick at different times
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, AI_TICK_FREQUENCY)

func setup(context_player: Player, context_ball: Ball) -> void:
	player = context_player
	ball = context_ball
	
func process_ai() -> void:
	if (Time.get_ticks_msec() - time_since_last_ai_tick) > AI_TICK_FREQUENCY:
		time_since_last_ai_tick = Time.get_ticks_msec()
		perform_ai_movement()
		perform_ai_decisions()
	
func perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	total_steering_force += get_on_duty_steering_force()
	total_steering_force = total_steering_force.limit_length(1.0)
	
	print("total steering force: " + str(total_steering_force))
	
	player.velocity = total_steering_force * player.speed
	
func perform_ai_decisions() -> void:
	pass
	
func get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)
