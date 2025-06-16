class_name Player
extends CharacterBody2D

const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.P1: preload("res://assets/assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/assets/art/props/2p.png"),
	ControlScheme.CPU: preload("res://assets/assets/art/props/cpu.png"),
}

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING, PASSING}

@export var control_scheme : ControlScheme
@export var speed : float
@export var power : float
@export var ball : Ball

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var control_sprite : Sprite2D = %ControlSprite
@onready var player_sprite : Sprite2D = %PlayerSprite
@onready var teammate_detection_area : Area2D = %TeammateDetectionArea

var current_state : PlayerState = null
var heading : Vector2 = Vector2.RIGHT
var state_factory := PlayerStateFactory.new()

func _ready() -> void:
	switch_state(State.MOVING)
	set_control_texture()

func _process(_delta: float) -> void:
	flip_sprite()
	set_sprite_visibility()
	move_and_slide()
	
func switch_state(state: State, player_state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_state_data, animation_player, ball, teammate_detection_area)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)

	# doesn't interfere with removing the pre-existing state
	call_deferred("add_child", current_state)	
	
func set_movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func set_heading() -> void:
	if velocity.x < 0:
		heading = Vector2.LEFT
	elif velocity.x > 0:
		heading = Vector2.RIGHT
		
func flip_sprite() -> void:
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true
		
func has_ball() -> bool:
	return ball.carrier == self

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]
	
func set_sprite_visibility() -> void:
	if control_scheme == ControlScheme.CPU:
		control_sprite.visible = has_ball()
	else:
		control_sprite.visible = true
