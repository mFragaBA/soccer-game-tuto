class_name MainMenuScreen
extends Control

const MENU_TEXTURES := [
	[
		preload("res://assets/assets/art/ui/mainmenu/1-player.png"),
		preload("res://assets/assets/art/ui/mainmenu/1-player-selected.png")
	],
	[
		preload("res://assets/assets/art/ui/mainmenu/2-players.png"),
		preload("res://assets/assets/art/ui/mainmenu/2-players-selected.png")
	]
]

@onready var selectable_menu_nodes : Array[TextureRect] = [
	%SinglePlayerTexture,
	%TwoPlayersTexture
]
@onready var selection_icon : TextureRect = %SelectionIcon

var current_selected_index := 0
var is_active := false

func _ready() -> void:
	refresh_ui()
	
func _process(_delta: float) -> void:
	if is_active:
		if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.DOWN):
			current_selected_index = (current_selected_index + 1) % selectable_menu_nodes.size()
			SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
		elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.UP):
			current_selected_index = (current_selected_index + selectable_menu_nodes.size() - 1) % selectable_menu_nodes.size()
			SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
		elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
			submit_selection()
			SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)	
	
	refresh_ui()
	
func refresh_ui() -> void:
	for i in range(0, selectable_menu_nodes.size()):
		selectable_menu_nodes[i].texture = MENU_TEXTURES[i][1] if i == current_selected_index else MENU_TEXTURES[i][0]

	selection_icon.position = Vector2(selection_icon.position.x, selectable_menu_nodes[current_selected_index].position.y)

func submit_selection() -> void:
	var default_country := DataLoader.get_countries()[1]
	var player_two := "" if current_selected_index == 0 else default_country
	GameManager.player_setup = [default_country, player_two]

func on_start_animation_finished() -> void:
	is_active = true
