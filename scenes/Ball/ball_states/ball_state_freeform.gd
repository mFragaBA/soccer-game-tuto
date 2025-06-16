class_name BallStateFreeform
extends BallState

const FRICTION_AIR := 0.02

# Affects friction, but it's a global parameter
const MAX_DRAG := 100.0

var court_params_factory := CourtParamsFactory.new()
var current_court_params : CourtParameters = court_params_factory.get_court_params(
		CourtParamsFactory.CourtType.GRASS
	)

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_player_enter.bind())
	
func on_player_enter(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)
	
func _process(delta: float) -> void:
	set_animation_from_velocity()
	
	var friction := MAX_DRAG * (FRICTION_AIR if ball.height > 0 else current_court_params.friction)
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, current_court_params.bounciness)
	ball.move_and_collide(ball.velocity * delta)
