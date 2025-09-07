class_name FlagSelector
extends Control

@onready var animation_player : AnimationPlayer = %AnimationPlayer

@export var control_scheme : Player.ControlScheme

var is_selected := false

func _process(_delta: float) -> void:
	if not is_selected and KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.SHOOT):
		is_selected = true
		animation_player.play("selected")
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
	elif is_selected and KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.PASS):
		is_selected = false
		animation_player.play("selecting")
		
