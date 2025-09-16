class_name TeamResource
extends Resource

@export var players : Array[PlayerResource]
@export var palette : ImageTexture

func _init(team_players: Array[PlayerResource], team_palette: Array[Color]) -> void:
	players = team_players
	
	var palette_image = Image.create_empty(6, 2, false, Image.FORMAT_RGB8)
	
	for i in range(DataLoader.DEFAULT_PALETTE.size()):
		palette_image.set_pixel(i, 0, DataLoader.DEFAULT_PALETTE[i])
		
	for i in range(team_palette.size()):
		palette_image.set_pixel(i, 1, team_palette[i])
	
	palette = ImageTexture.create_from_image(palette_image)
