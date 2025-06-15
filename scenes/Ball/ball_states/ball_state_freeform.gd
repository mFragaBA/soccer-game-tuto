class_name BallStateFreeform
extends BallState

const FRICTION_AIR := 0.02
# TODO: have different fields and Friction coefficient based on them
#Concrete: 0.6 – 0.85
#Hardwood floor: 0.4 – 0.6
#Turf/Artificial grass: 0.6 – 0.8
#Natural grass: 0.2 – 0.55
const FRICTION_GROUNDED := 0.25
# Affects friction, but it's a global parameter
const MAX_DRAG := 100.0

# TODO: have different fields and Bounciness coefficient based on them
#Concrete: 0.9 – 0.95
#Hardwood floor: 0.85 – 0.9
#Turf/Artificial grass: 0.4 – 0.6
#Natural grass: 0.1 – 0.5
const BOUNCINESS := 0.4

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(on_player_enter.bind())
	
func on_player_enter(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)
	
func _process(delta: float) -> void:
	set_animation_from_velocity()
	
	var friction := MAX_DRAG * (FRICTION_AIR if ball.height > 0 else FRICTION_GROUNDED)
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, BOUNCINESS)
	ball.move_and_collide(ball.velocity * delta)
