class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

var animation_player : AnimationPlayer = null
var player : Player = null
var ball : Ball = null
var teammate_detection_area : Area2D = null
var ball_detection_area : Area2D = null
var own_goal : Goal = null
var target_goal : Goal = null
var state_data : PlayerStateData = PlayerStateData.new()
var tackle_damage_emitter_area : Area2D = null
var ai_behavior : AIBehavior = null

func setup(context_player: Player, context_data: PlayerStateData, context_animation_player: AnimationPlayer, context_ball: Ball, context_teammate_detection_area: Area2D, context_ball_detection_area: Area2D, context_own_goal: Goal, context_target_goal : Goal, context_tackle_damage_emitter_area: Area2D, context_ai_behavior : AIBehavior) -> void:
	player = context_player
	state_data = context_data
	animation_player = context_animation_player
	teammate_detection_area = context_teammate_detection_area
	ball_detection_area = context_ball_detection_area
	own_goal = context_own_goal
	target_goal = context_target_goal
	ball = context_ball
	tackle_damage_emitter_area = context_tackle_damage_emitter_area
	ai_behavior = context_ai_behavior
	
func transition_state(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)

func on_animation_complete() -> void:
	pass # Override method

func can_carry_ball() -> bool:
	return false
