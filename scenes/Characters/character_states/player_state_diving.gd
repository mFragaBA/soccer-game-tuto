class_name PlayerStateDiving
extends PlayerState

const DIVE_DURATION := 500

var dive_start_time := Time.get_ticks_msec()

func _enter_tree() -> void:
	var target_dive := Vector2(player.spawn_position.x, ball.position.y)
	var direction := player.position.direction_to(target_dive)
	
	var dive_animation = "dive_down" if direction.y > 0 else "dive_up"
	
	animation_player.play(dive_animation)
	player.velocity = player.speed * direction
	
	dive_start_time = Time.get_ticks_msec()
	
func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - dive_start_time > DIVE_DURATION:
		transition_state(Player.State.RECOVERING)
