class_name BallStateFreeform
extends BallState

const MAX_CAPTURE_HEIGHT := 25.0

var time_since_freeform := Time.get_ticks_msec()

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_player_enter.bind())
	time_since_freeform = Time.get_ticks_msec()
	
func on_player_enter(body: Player) -> void:	
	if body.can_carry_ball() and ball.height < MAX_CAPTURE_HEIGHT:
		ball.carrier = body
		body.control_ball()
		transition_state(Ball.State.CARRIED)
	
func _process(delta: float) -> void:
	player_detection_area.monitoring = Time.get_ticks_msec() - time_since_freeform >= state_data.ball_lock_duration_ms
	
	set_animation_from_velocity()
	
	var friction := Ball.MAX_DRAG * (Ball.FRICTION_AIR if ball.height > 0 else court_params.friction)
	
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, court_params.bounciness)
	move_and_bounce(delta)
	
func can_air_interact() -> bool:
	return true
