class_name TeamResource
extends Resource

@export var name : String
@export var players : Array[PlayerResource]
@export var palette : ImageTexture
@export var palette_colors : Array[Color]
@export var team_flag : ImageTexture

func _init(team_name: String = "New Team", team_players: Array[PlayerResource] = [], team_palette: Array[Color] = DataLoader.DEFAULT_PALETTE) -> void:
	name = team_name
	players = team_players
	update_palette(team_palette)

func update_palette(team_palette_colors : Array[Color]) -> void:
	palette_colors = team_palette_colors
	# initialize team palette
	var palette_image = Image.create_empty(6, 2, false, Image.FORMAT_RGB8)
	
	for i in range(DataLoader.DEFAULT_PALETTE.size()):
		palette_image.set_pixel(i, 0, DataLoader.DEFAULT_PALETTE[i])
		
	for i in range(palette_colors.size()):
		palette_image.set_pixel(i, 1, palette_colors[i])
	
	palette = ImageTexture.create_from_image(palette_image)
