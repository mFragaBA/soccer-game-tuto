class_name Camera
extends Camera2D

const DISTANCE_TARGET := 100.0
const SMOOTHING_BALL_CARRIED := 2
const SMOOTHING_BALL_DEFAULT := 8


@export var ball : Ball

func _process(_delta: float) -> void:
	if ball.carrier != null:
		position_smoothing_speed = SMOOTHING_BALL_CARRIED
		position = ball.carrier.position + ball.carrier.heading * DISTANCE_TARGET
	else:
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT
		position = ball.position
