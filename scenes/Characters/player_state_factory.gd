class_name PlayerStateFactory
extends Object

var states : Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.PREPPING_SHOT: PlayerStatePreppingShot,
		Player.State.SHOOTING: PlayerStateShooting,
		Player.State.PASSING: PlayerStatePassing,
		Player.State.BICYCLE_KICK: PlayerStateBicycleKick,
		Player.State.VOLLEY_KICK: PlayerStateVolleyKick,
		Player.State.HEADER: PlayerStateHeader,
		Player.State.CHEST_CONTROL: PlayerStateChestControl,
		Player.State.HURT: PlayerStateHurt,
		Player.State.DIVING: PlayerStateDiving,
		Player.State.CELEBRATING: PlayerStateCelebrating,
		Player.State.MOURNING: PlayerStateMourning,
	}
	
func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "State doesn't exist")
	return states.get(state).new()
