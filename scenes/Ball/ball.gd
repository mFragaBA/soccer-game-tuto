class_name Ball
extends AnimatableBody2D

enum State { CARRIED, FREEFORM, SHOT }

@onready var player_detection_area : Area2D = %PlayerDetectionArea
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var ball_sprite : Sprite2D = %BallSprite

@export var court_type : CourtParamsFactory.CourtType = CourtParamsFactory.CourtType.GRASS

# Affects friction, but it's a global parameter
const FRICTION_AIR := 0.02
const MAX_DRAG := 100.0

var velocity := Vector2.ZERO
var state_factory := BallStateFactory.new()
var current_state : BallState = null
var court_params_factory := CourtParamsFactory.new()
var current_court_params : CourtParameters = court_params_factory.get_court_params(
		court_type
	)
var carrier : Player = null
var height := 0.0
var height_velocity := 0.0

func _ready() -> void:
	switch_state(State.FREEFORM)
	
func _process(_delta) -> void:
	ball_sprite.position = Vector2.UP * height

func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_detection_area, carrier, animation_player, ball_sprite, current_court_params)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMachine"
	call_deferred("add_child", current_state)

func shoot(shot_velocity: Vector2) -> void:
	velocity = shot_velocity
	carrier = null
	switch_state(State.SHOT)
	
func pass_to(destination: Vector2) -> void:
	var pass_direction = position.direction_to(destination)
	var pass_distance = position.distance_to(destination)
	
	var friction_force := current_court_params.friction * MAX_DRAG
	velocity = sqrt(2 * pass_distance * friction_force) * pass_direction
	carrier = null
	switch_state(State.FREEFORM)

func stop() -> void:
	velocity = Vector2.ZERO
