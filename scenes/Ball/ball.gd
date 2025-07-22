class_name Ball
extends AnimatableBody2D

enum State { CARRIED, FREEFORM, SHOT }

@onready var player_detection_area : Area2D = %PlayerDetectionArea
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var ball_sprite : Sprite2D = %BallSprite
@onready var scoring_raycast : RayCast2D = %ScoringRaycast

@export var court_type : CourtParamsFactory.CourtType = CourtParamsFactory.CourtType.SAMPLE

# Affects friction, but it's a global parameter
const FRICTION_AIR := 0.05
const MAX_DRAG := 1000.0
const GRAVITY_FORCE := 10.0
const DISTANCE_HIGH_PASS := 130
const TUMBLE_HEIGHT_VELOCITY := 3.0
const DURATION_TUMBLE_LOCK := 200.0
const DURATION_PASS_LOCK := 500.0
const KICKOFF_PASS_DISTANCE := 30.0

var velocity := Vector2.ZERO
var state_factory := BallStateFactory.new()
var current_state : BallState = null
var court_params_factory := CourtParamsFactory.new()
var current_court_params : CourtParameters
var carrier : Player = null
var height := 0.0
var height_velocity := 0.0

var initial_position : Vector2

func _ready() -> void:
	current_court_params = court_params_factory.get_court_params(
		court_type
	)
	switch_state(State.FREEFORM)
	initial_position = position
	
	GameEvents.team_reset.connect(on_team_reset.bind())
	GameEvents.kickoff_started.connect(on_kickoff_started.bind())

	
func _process(_delta) -> void:
	ball_sprite.position = Vector2.UP * height
	scoring_raycast.rotation = velocity.angle()

func switch_state(state: State, state_data: BallStateData = BallStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_detection_area, carrier, animation_player, ball_sprite, current_court_params, state_data)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "BallStateMachine"
	call_deferred("add_child", current_state)

func shoot(shot_velocity: Vector2) -> void:
	velocity = shot_velocity
	height_velocity = 0
	carrier = null
	switch_state(State.SHOT)
	
func tumble(tumble_velocity: Vector2) -> void:
	velocity = tumble_velocity
	carrier = null
	height_velocity = TUMBLE_HEIGHT_VELOCITY
	
	var new_state_data = BallStateData.new()
	new_state_data.ball_lock_duration_ms = DURATION_TUMBLE_LOCK
	
	switch_state(State.FREEFORM, new_state_data)
	
func pass_to(destination: Vector2, lock_duration : float = DURATION_PASS_LOCK) -> void:
	var pass_direction = position.direction_to(destination)
	var pass_distance = position.distance_to(destination)
	
	var friction_force := current_court_params.friction * MAX_DRAG
	var horizontal_velocity_magnitude := sqrt(2 * pass_distance * friction_force)
	velocity = horizontal_velocity_magnitude * pass_direction
	
	if pass_distance > DISTANCE_HIGH_PASS:
		# Note: this is technically not precise. Because the horizontal velocity 
		# magnitude is calculated assuming fround friction which is higher than air friction
		# the pass would actually go past the player if the player is not there to receive it
		# That being said, if we do the calculation with air friction, the velocity is really slow
		# and the ball takes much longer to reach the player and thus to compensate the height 
		# must be greater to compensate for all that extra time, which makes the trajectory look
		# awful. Also use 1.8 instead of 2 so that it reaches better for a header
		height_velocity = GRAVITY_FORCE * pass_distance / (1.8 * horizontal_velocity_magnitude)
	
	carrier = null
	var new_state_data = BallStateData.new()
	new_state_data.ball_lock_duration_ms = lock_duration
	
	switch_state(State.FREEFORM, new_state_data)

func stop() -> void:
	velocity = Vector2.ZERO

func can_air_interact() -> bool:
	return current_state != null and current_state.can_air_interact()

func can_air_connect(air_connect_min_height, air_connect_max_height) -> bool:
	return height >= air_connect_min_height and height <= air_connect_max_height

func is_headed_for_scoring_area(scoring_area: Area2D):
	if not scoring_raycast.is_colliding():
		return false
	return scoring_raycast.get_collider() == scoring_area
	
func on_team_reset() -> void:
	position = initial_position
	velocity = Vector2.ZERO
	height_velocity = 0
	switch_state(State.FREEFORM)

func on_kickoff_started() -> void:
	pass_to(initial_position + KICKOFF_PASS_DISTANCE * Vector2.DOWN, 0)
