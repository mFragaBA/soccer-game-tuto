class_name ScreenFactory

var screens : Dictionary

func _init() -> void:
	screens = {
		SoccerGame.ScreenType.IN_GAME: preload("res://scenes/Screens/world/world_screen.tscn"),
		SoccerGame.ScreenType.MAIN_MENU: preload("res://scenes/Screens/main_menu/main_menu_screen.tscn"),
		SoccerGame.ScreenType.TEAM_SELECTION: preload("res://scenes/Screens/team_selection/team_selection_screen.tscn")
	}
	
func get_fresh_screen(screen_type: SoccerGame.ScreenType) -> Screen:
	assert(screens.has(screen_type), "screen does not exist!")
	return screens.get(screen_type).instantiate()
