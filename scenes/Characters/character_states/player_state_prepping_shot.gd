class_name PlayerStatePreppingShot
extends PlayerState

const DURATION_MAX_BONUS := 1000.0
const EASE_REWARD_FACTOR := 2.0

var shot_direction := Vector2.ZERO
var time_start_shot := Time.get_ticks_msec()

func _enter_tree() -> void:
	animation_player.play("prep_kick")
	player.velocity = Vector2.ZERO
	
func _process(delta: float) -> void:
	shot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta
	
	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var bonus := calculate_shot_bonus()
		var shot_power = player.power * (1 + bonus)
		shot_direction = shot_direction.normalized()
		
		var state_data := PlayerStateData.new()
		state_data.shot_direction = shot_direction
		state_data.shot_power = shot_power
		
		transition_state(Player.State.SHOOTING, state_data)
		
# Shot bonus is a multiplier in the [0, 1] range corresponding 
# to the amount of time spent prepping the kick. The longer you
# charge it, the stronger it is. We use an ease function that 
# incentivizes holding for longer at the risk of getting swept
func calculate_shot_bonus() -> float:
	var time_bonus := clampf(Time.get_ticks_msec() - time_start_shot, 0, DURATION_MAX_BONUS)
	var ease_time := time_bonus / DURATION_MAX_BONUS
	return ease(ease_time, EASE_REWARD_FACTOR)
