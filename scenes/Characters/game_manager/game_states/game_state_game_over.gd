class_name GameStateGameOver
extends GameState

func _enter_tree() -> void:
	var winning_country := game_manager.get_winning_country()
	GameEvents.game_over.emit(winning_country)
