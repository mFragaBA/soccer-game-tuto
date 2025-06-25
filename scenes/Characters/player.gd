class_name Player
extends CharacterBody2D

const BALL_CONTROL_HEIGHT := 5.0
const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.P1: preload("res://assets/assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/assets/art/props/2p.png"),
	ControlScheme.CPU: preload("res://assets/assets/art/props/cpu.png"),
}

const COUNTRIES := ["DEFAULT", "FRANCE", "ARGENTINA", "BRAZIL", "ENGLAND", "GERMANY", "ITALY", "SPAIN", "USA", "BOCA", "INDEPENDIENTE", "RIVER", "RACING", "SAN LORENZO"]

const GRAVITY := 8.0
const WALK_ANIM_THRESHOLD := 0.6

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL}
enum Role {GOALIE, DEFENSE, MIDFIELD, OFFENSE}
enum SkinColor {LIGHT, MEDIUM, DARK}

@export var control_scheme : ControlScheme
@export var speed : float
@export var power : float
@export var ball : Ball
@export var own_goal : Goal
@export var target_goal : Goal

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var control_sprite : Sprite2D = %ControlSprite
@onready var player_sprite : Sprite2D = %PlayerSprite
@onready var teammate_detection_area : Area2D = %TeammateDetectionArea
@onready var ball_detection_area : Area2D = %BallDetectionArea

var ai_behavior : AIBehavior = AIBehavior.new()
var current_state : PlayerState = null
var heading : Vector2 = Vector2.RIGHT
var height : float = 0.0
var height_velocity : float = 0.0
var fullname : String = ""
var role : Role = Role.MIDFIELD
var skin_color: SkinColor = SkinColor.MEDIUM
var country: String = ""
var spawn_position := Vector2.ZERO
var state_factory := PlayerStateFactory.new()
var weight_on_duty_steering := 0.0

func initialize(context_position: Vector2, context_ball: Ball, context_own_goal: Goal, context_target_goal: Goal, context_player_data: PlayerResource, context_player_country: String) -> void:
	position = context_position
	ball = context_ball
	own_goal = context_own_goal
	target_goal = context_target_goal
	fullname = context_player_data.full_name
	role = context_player_data.role
	skin_color = context_player_data.skin_color
	speed = context_player_data.speed
	power = context_player_data.power
	country = context_player_country
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT

func _ready() -> void:
	switch_state(State.MOVING)
	set_control_texture()
	set_shader_properties()
	setup_ai()
	spawn_position = position
	
func _process(delta: float) -> void:
	flip_sprite()
	set_sprite_visibility()
	process_gravity(delta)
	move_and_slide()
	
func set_shader_properties() -> void:
	player_sprite.material.set_shader_parameter("skin_index", skin_color)
	var country_color := COUNTRIES.find(country)
	country_color = clampi(country_color, 0, COUNTRIES.size() - 1)
	player_sprite.material.set_shader_parameter("team_index", country_color)
	
func switch_state(state: State, player_state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_state_data, animation_player, ball, teammate_detection_area, ball_detection_area, own_goal, target_goal, ai_behavior)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)

	# doesn't interfere with removing the pre-existing state
	call_deferred("add_child", current_state)	
	
func setup_ai() -> void:
	ai_behavior.setup(self, ball)
	ai_behavior.name = "AI Behavior"
	add_child(ai_behavior)
	
func set_movement_animation() -> void:
	var vel_length := velocity.length()
	if vel_length < 1:
		animation_player.play("idle")
	elif vel_length < speed * WALK_ANIM_THRESHOLD:
		animation_player.play("walk")
	else:
		animation_player.play("run")


func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height < 0:
			height = 0
			
	player_sprite.position = Vector2.UP * height

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
	
func is_facing_target_goal() -> bool:
	var direction_to_target_goal := position.direction_to(target_goal.position)
	
	# Cos > 0 deg means the angle is between -90 and 90
	return heading.dot(direction_to_target_goal) > 0
	
func set_sprite_visibility() -> void:
	if control_scheme == ControlScheme.CPU:
		control_sprite.visible = has_ball()
	else:
		control_sprite.visible = true

func control_ball() -> void:
	if ball.height > BALL_CONTROL_HEIGHT:
		switch_state(Player.State.CHEST_CONTROL)
