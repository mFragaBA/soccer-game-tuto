class_name PlayerStateFactory
extends Object

var states : Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
	}
	
func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "State doesn't exist")
	return states.get(state).new()
