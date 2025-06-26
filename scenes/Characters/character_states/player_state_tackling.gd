class_name PlayerStateTackling
extends PlayerState

const DELAY_AFTER_FULL_STOP := 200
const FLOOR_FRICTION := 150

var stopped = false
var time_start_tackle_stop = Time.get_ticks_msec()

func _enter_tree() -> void:
	tackle_damage_emitter_area.monitoring = true
	animation_player.play("tackle")

func _process(delta: float) -> void:
	if not stopped:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, FLOOR_FRICTION * delta)
		
		# Check if we've fully stopped
		if player.velocity == Vector2.ZERO:
			time_start_tackle_stop = Time.get_ticks_msec()
			stopped = true
	
	if stopped and (Time.get_ticks_msec() - time_start_tackle_stop) > DELAY_AFTER_FULL_STOP:
		transition_state(Player.State.RECOVERING)
		
func _exit_tree() -> void:
	tackle_damage_emitter_area.monitoring = false
