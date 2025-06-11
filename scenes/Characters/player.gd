class_name Player
extends CharacterBody2D

const TACKLE_DURATION := 200
enum State {MOVING, TACKLING}

enum ControlScheme {CPU, P1, P2}

@export var control_scheme : ControlScheme
@export var speed : float

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var player_sprite : Sprite2D = %PlayerSprite

var heading : Vector2 = Vector2.RIGHT
var state := State.MOVING
var time_start_tackle := Time.get_ticks_msec()

func _process(delta: float) -> void:
	if control_scheme == ControlScheme.CPU:
		pass
	else:
		if state == State.MOVING:
			handle_human_movement()
			if velocity.x != 0 && KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.SHOOT):
				state = State.TACKLING
				time_start_tackle = Time.get_ticks_msec()
			set_movement_animation()
		elif state == State.TACKLING:
			animation_player.play("tackle")
			if Time.get_ticks_msec() - time_start_tackle > TACKLE_DURATION:
				state = State.MOVING

func handle_human_movement() -> void:
	var direction := KeyUtils.get_input_vector(control_scheme)
	velocity = direction * speed
	
	# TODO: should it be moved to physics process?
	move_and_slide()
	set_heading()
	flip_sprite()
	
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
