class_name TeamSelectionScreen
extends Screen

const FLAG_ANCHOR_POINT := Vector2(25, 70)
const N_ROWS := 3
const N_COLS := 5

const HORIZONTAL_MARGIN := 50
const VERTICAL_MARGIN := 35

@onready var flags_container : Control = %FlagsContainer
@onready var selectors : Array[CarouselSelector] = [%P1CarouselSelector, %P2CarouselSelector]
@onready var flag_selectors : Array[FlagSelector] = [%P1FlagSelector, %P2FlagSelector]
@onready var selected_team_labels : Array[Label] = [%P1SelectedTeam, %P2SelectedTeam]

var selection : Array[int] = [0, 0]
var countries : Array[String] = []

func _ready() -> void:
	countries = DataLoader.get_countries().slice(1)
	
	# Initialize flag textures for all players
	for selector in selectors:
		var flag_textures : Array[TextureRect] = []
		for country in countries:
			var flag_texture := TextureRect.new()
			flag_texture.texture = FlagHelper.get_texture(country)
			flag_texture.size = Vector2(44, 28)
			flag_texture.custom_minimum_size = Vector2(44, 28)
			#flag_texture.z_index = 1
			flag_textures.append(flag_texture)
		
		selector.initialize(flag_textures)
		
	if GameManager.player_setup[1].is_empty():
		flag_selectors[1].queue_free()
		selectors[1].queue_free()
		selected_team_labels[1].queue_free()
		flag_selectors.pop_back()
		selectors.pop_back()
		selected_team_labels.pop_back()
		selection.pop_back()
		
	update_selected_team_labels()
		
func _process(_delta: float) -> void:
	for i in range(selectors.size()):
		if flag_selectors[i].is_selected:
			continue
			
		if KeyUtils.is_action_just_pressed(flag_selectors[i].control_scheme, KeyUtils.Action.RIGHT):
			try_navigate(i, 1)
		if KeyUtils.is_action_just_pressed(flag_selectors[i].control_scheme, KeyUtils.Action.LEFT):
			try_navigate(i, -1)
	
	if not flag_selectors[0].is_selected and KeyUtils.is_action_just_pressed(flag_selectors[0].control_scheme, KeyUtils.Action.PASS):
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
		transition_screen(SoccerGame.ScreenType.MAIN_MENU)
		
	update_selected_team_labels()
		
	## Start Match / Tournament
	if flag_selectors.all(func(selector): return selector.is_selected):
		var country_p1 = GameManager.player_setup[0]
		var country_p2 = GameManager.player_setup[1]
		
		if not country_p2.is_empty() and country_p1 != country_p2:
			GameManager.current_match = Match.new(country_p2, country_p1)
			transition_screen(SoccerGame.ScreenType.IN_GAME)
		else:
			var data := ScreenData.new()
			data.tournament = TournamentBuilder.new().with_amount_of_teams(8).with_team(country_p1).build()
			transition_screen(SoccerGame.ScreenType.TOURNAMENT, data)
		
				
func try_navigate(selector_idx: int, offset: int) -> void:
	var prev_selection = selection[selector_idx]
	selection[selector_idx] = (selection[selector_idx] + countries.size() + offset) % countries.size()
	selectors[selector_idx].roll(prev_selection, selection[selector_idx])
	GameManager.player_setup[selector_idx] = countries[selection[selector_idx]]
	SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	
func update_selected_team_labels() -> void:
	for i in range(selected_team_labels.size()):
		selected_team_labels[i].text = countries[selection[i]]
