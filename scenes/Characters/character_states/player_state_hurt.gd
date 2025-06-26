class_name PlayerStateHurt
extends PlayerState

const DURATION_HURT := 1000
const AIR_FRICTION := 35
const HURT_HEIGHT_VELOCITY := 1.25
const TUMBLE_SPEED := 100

var time_hurt_started := Time.get_ticks_msec()

func _enter_tree() -> void:
	animation_player.play("hurt")
	time_hurt_started = Time.get_ticks_msec()
	player.height_velocity = HURT_HEIGHT_VELOCITY
	player.height = 0.01
	if ball.carrier == player:
		ball.tumble(state_data.hurt_direction * TUMBLE_SPEED)
	
func _process(delta: float) -> void:
	if (Time.get_ticks_msec() - time_hurt_started) > DURATION_HURT:
		transition_state(Player.State.RECOVERING)
		
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
