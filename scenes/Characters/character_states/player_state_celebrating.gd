class_name PlayerStateCelebrating
extends PlayerState

const CELEBRATING_HEIGHT_VELOICITY := 1.5
const AIR_FRICTION := 60.0

var initial_celebrate_delay := randf_range(200, 500)
var time_since_celebrating := Time.get_ticks_msec()

func _enter_tree() -> void:
	celebrate()
	GameEvents.team_reset.connect(on_team_reset.bind())
	
func _process(delta: float) -> void:
	if player.height == 0 and Time.get_ticks_msec() - time_since_celebrating > initial_celebrate_delay:
		celebrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
	
func celebrate() -> void:
	animation_player.play("celebrate")
	player.height = 0.1
	player.height_velocity = CELEBRATING_HEIGHT_VELOICITY

func on_team_reset() -> void:
	var data := PlayerStateData.new()
	data.reset_position = player.spawn_position
	transition_state(Player.State.RESETTING, data)
