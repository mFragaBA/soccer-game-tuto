class_name TeamSelectionScreen
extends Screen

const FLAG_ANCHOR_POINT := Vector2(25, 70)
const FLAG_SELECTOR_PREFAB := preload("res://scenes/Screens/team_selection/flag_selector.tscn")
const N_ROWS := 3
const N_COLS := 5

const HORIZONTAL_MARGIN := 50
const VERTICAL_MARGIN := 35

@onready var flags_container : Control = %FlagsContainer

var selection : Array[Vector2i] = [Vector2i.ZERO, Vector2i.ZERO]
var selectors : Array[FlagSelector] = []
var countries : Array[String] = []

func _ready() -> void:
	countries = DataLoader.get_countries()
	
	place_flags()
	place_selectors()
	
func _process(_delta: float) -> void:
	for i in range(selectors.size()):
		var selector = selectors[i]
		if not selector.is_selected:
			if KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.RIGHT):
				try_navigate(i, Vector2i.RIGHT)
			if KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.LEFT):
				try_navigate(i, Vector2i.LEFT)
			if KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.UP):
				try_navigate(i, Vector2i.UP)
			if KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.DOWN):
				try_navigate(i, Vector2i.DOWN)
				
	if not selectors[0].is_selected and KeyUtils.is_action_just_pressed(selectors[0].control_scheme, KeyUtils.Action.PASS):
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
		transition_screen(SoccerGame.ScreenType.MAIN_MENU)
		
	# Start Match / Tournament
	if selectors.all(func(selector): return selector.is_selected):
		var country_p1 = GameManager.player_setup[0]
		var country_p2 = GameManager.player_setup[1]
		
		if not country_p2.is_empty() and country_p1 != country_p2:
			GameManager.countries = [country_p2, country_p1]
			transition_screen(SoccerGame.ScreenType.IN_GAME)
		
				
func try_navigate(selector_idx: int, offset: Vector2i) -> void:
	selection[selector_idx].x = (selection[selector_idx].x + offset.y + N_ROWS) % N_ROWS
	selection[selector_idx].y = (selection[selector_idx].y + offset.x + N_COLS) % N_COLS
	
	# update selector position
	var selected_country_idx := selection[selector_idx].x * N_COLS + selection[selector_idx].y

	if selected_country_idx < (countries.size() - 1):
		selectors[selector_idx].position = flags_container.get_child(selected_country_idx).position
		GameManager.player_setup[selector_idx] = countries[1 + selected_country_idx]
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	else:
		# repeat movement (this ensures we wrap over the sides) if we don't have a full
		# square
		try_navigate(selector_idx, offset)
	
func place_flags() -> void:
	for i in range(N_ROWS):
		for j in range(N_COLS):
			var country_index := 1 + i * N_COLS + j
			
			if country_index >= countries.size():
				continue
			
			var country := countries[country_index]
			var flag_texture := TextureRect.new()
			flag_texture.position = FLAG_ANCHOR_POINT + Vector2(HORIZONTAL_MARGIN * j, VERTICAL_MARGIN * i)
			flag_texture.texture = FlagHelper.get_texture(country)
			flag_texture.scale = Vector2(2, 2)
			#flag_texture.z_index = 1
			flags_container.add_child(flag_texture)

func place_selectors() -> void:
	add_selector(Player.ControlScheme.P1)
	if not GameManager.player_setup[1].is_empty():
		add_selector(Player.ControlScheme.P2)
	
func add_selector(control_scheme: Player.ControlScheme) -> void:
	var selector := FLAG_SELECTOR_PREFAB.instantiate()
	selector.position = flags_container.get_child(0).position
	selector.control_scheme = control_scheme
	selectors.append(selector)
	flags_container.add_child(selector)
