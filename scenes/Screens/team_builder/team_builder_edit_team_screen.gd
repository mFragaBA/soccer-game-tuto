class_name TeamBuilderEditTeamScreen
extends Screen

@onready var sample_sprite = %SampleSprite
@onready var color_pickers = [%Color1, %Color2, %Color3, %Color4, %Color5, %Color6]

var team : TeamResource = null

func _ready() -> void:
	team = TeamResource.new()
	
	for i in range(color_pickers.size()):
		color_pickers[i].color = team.palette_colors[i]
	
	update_sample_sprite()

func update_sample_sprite() -> void:
	sample_sprite.material.set_shader_parameter("team_palette", team.palette)
	sample_sprite.material.set_shader_parameter("team_index", 1)
	
func update_team_colors() -> void:
	var colors : Array[Color] = []
	for picker in color_pickers:
		colors.append(picker.color)
		
	team.update_palette(colors)
	update_sample_sprite()
