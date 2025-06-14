class_name Ball
extends AnimatableBody2D

enum State { CARRIED, FREEFORM, SHOT }

@onready var player_detection_area : Area2D = %PlayerDetectionArea
@onready var animation_player : AnimationPlayer = %AnimationPlayer

var velocity := Vector2.ZERO
var state_factory := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null

func _ready() -> void:
	switch_state(State.FREEFORM)

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_detection_area, carrier, animation_player)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMachine"
	call_deferred("add_child", current_state)
