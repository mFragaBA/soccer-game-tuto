class_name WorldScreen
extends Screen

@onready var game_over_timer : Timer = %GameOverTimer

func _ready() -> void:
	GameManager.start_game()
	GameEvents.game_over.connect(on_game_over.bind())
	game_over_timer.timeout.connect(on_transition.bind())
	
func on_game_over(_winner: String) -> void:
	game_over_timer.start()
	
func on_transition() -> void:
	if screen_data.tournament != null and GameManager.current_match.winner == GameManager.player_setup[0]:
		# Go into tournament screen	
		screen_data.tournament.advance_stage()
		transition_screen(SoccerGame.ScreenType.TOURNAMENT, screen_data)
	else:
		transition_screen(SoccerGame.ScreenType.MAIN_MENU)
