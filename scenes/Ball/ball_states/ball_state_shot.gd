class_name BallStateShot
extends BallState

const SHOT_DURATION_MS = 1000
const SHOT_SPRITE_SCALE := 0.8 
const SHOT_HEIGHT_PX := 5

var time_shot_started := Time.get_ticks_msec()

func _enter_tree() -> void:
	if ball.velocity.x > 0:
		animation_player.play("roll")
	else:
		animation_player.play_backwards("roll")
	
	animation_player.advance(0)
	ball.height = SHOT_HEIGHT_PX
	sprite.scale.y = SHOT_SPRITE_SCALE
	time_shot_started = Time.get_ticks_msec()
		
func _process(delta: float) -> void:
	if (Time.get_ticks_msec() - time_shot_started) > SHOT_DURATION_MS:
		animation_player.play("idle")
		state_transition_requested.emit(Ball.State.FREEFORM)
	else:
		ball.move_and_collide(ball.velocity * delta)	

func _exit_tree() -> void:
	sprite.scale.y = 1
