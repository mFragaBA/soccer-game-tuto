class_name Camera
extends Camera2D

const DISTANCE_TARGET := 100.0
const SHAKE_DURATION := 90
const SHAKE_INTENSITY := 3
const SMOOTHING_BALL_CARRIED := 2
const SMOOTHING_BALL_DEFAULT := 8

var time_started_shaking := Time.get_ticks_msec()
var is_shaking := false

@export var ball : Ball

func _init() -> void:
	GameEvents.impact_received.connect(on_impact_received.bind())

func _process(_delta: float) -> void:
	if ball.carrier != null:
		position_smoothing_speed = SMOOTHING_BALL_CARRIED
		position = ball.carrier.position + ball.carrier.heading * DISTANCE_TARGET
	else:
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT
		position = ball.position
	
	if is_shaking and (Time.get_ticks_msec() - time_started_shaking) < SHAKE_DURATION:
		offset = Vector2(randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY), randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))

func on_impact_received(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		is_shaking = true
		time_started_shaking = Time.get_ticks_msec()
