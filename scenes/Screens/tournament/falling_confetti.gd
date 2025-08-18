class_name FallingConfetti
extends Node2D

const FALL_SPEED := 30 # 15 px per second

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var sprite : Sprite2D = %Sprite2D

func _ready() -> void:
	sprite.rotate(randf_range(0, deg_to_rad(360)))
	sprite.modulate = [Color.GOLD, Color.PALE_VIOLET_RED, Color.SILVER, Color.VIOLET].pick_random()
	animation_player.seek(randf_range(0, 0.5), true)

func _process(delta: float) -> void:
	sprite.position.y += delta * FALL_SPEED
