class_name BallStateFreeform
extends BallState

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_player_enter.bind())
	
func on_player_enter(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)
	
func _process(delta: float) -> void:
	set_animation_from_velocity()
	
	var friction := Ball.MAX_DRAG * (Ball.FRICTION_AIR if ball.height > 0 else court_params.friction)
	
	if ball.velocity != Vector2.ZERO:
		print(friction)
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, court_params.bounciness)
	move_and_bounce(delta)
	
func can_air_interact() -> bool:
	return true
