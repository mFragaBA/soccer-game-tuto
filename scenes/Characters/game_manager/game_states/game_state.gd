class_name GameState
extends Node

signal state_transition_requested(new_state: GameManager.State, state_data: GameStateData)

var game_manager : GameManager = null
var state_data : GameStateData = null

func setup(context_game_manager: GameManager, context_state_data: GameStateData) -> void:
	game_manager = context_game_manager
	state_data = context_state_data

func transition_state(new_state: GameManager.State, data : GameStateData = GameStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
