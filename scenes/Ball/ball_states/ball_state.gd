class_name BallState
extends Node

signal state_transition_requested(new_state: Ball.State)

var ball : Ball = null
var player_detection_area = null
var carrier = null
var animation_player = null

func setup(context_ball: Ball, context_player_detection_area: Area2D, context_carrier: Player, context_animation_player) -> void:
	ball = context_ball
	player_detection_area = context_player_detection_area
	carrier = context_carrier
	animation_player = context_animation_player
