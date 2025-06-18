class_name PlayerStateChestControl
extends PlayerState

const CONTROL_DURATION := 500

var time_entered_state := Time.get_ticks_msec()

func _enter_tree() -> void:
	player.velocity = Vector2.ZERO
	animation_player.play("chest_control")
	time_entered_state = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if (Time.get_ticks_msec() - time_entered_state) > CONTROL_DURATION:
		transition_state(Player.State.MOVING)		
