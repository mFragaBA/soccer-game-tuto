class_name PlayerStateCelebrating
extends PlayerState

const CELEBRATING_HEIGHT_VELOICITY := 1.5
const AIR_FRICTION := 35.0

func _enter_tree() -> void:
	celebrate()
	
func _process(delta: float) -> void:
	if player.height == 0:
		celebrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
	GameEvents.team_reset.connect(on_team_reset.bind())
	
func celebrate() -> void:
	animation_player.play("celebrate")
	player.height = 0.1
	player.height_velocity = CELEBRATING_HEIGHT_VELOICITY

func on_team_reset() -> void:
	var state_data := PlayerStateData.new()
	state_data.reset_position = player.spawn_position
	transition_state(Player.State.RESETTING, state_data)
