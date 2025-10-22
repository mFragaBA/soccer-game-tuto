class_name TeamBuilderEditTeamScreen
extends Screen

@onready var sample_sprite = %SampleSprite
@onready var color_pickers = [%Color1, %Color2, %Color3, %Color4, %Color5, %Color6]
@onready var team_flag = %TeamFlag
@onready var team_name_field = %TeamNameField

var team : TeamResource = null

func _ready() -> void:
	team = screen_data.edit_team if screen_data != null and screen_data.edit_team != null else TeamResource.new()
	
	# Team Details Tab
	team_name_field.text = team.name
	team_name_field.text_changed.connect(update_team_name)
	#team_flag.texture = team.team_flag
	
	# Uniform Tab
	for i in range(color_pickers.size()):
		color_pickers[i].init(team.palette_colors[i])
	
	update_sample_sprite()
	
func _process(_delta: float) -> void:
	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.PASS):
		save_team_resource()
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)	

func update_sample_sprite() -> void:
	sample_sprite.material.set_shader_parameter("team_palette", team.palette)
	sample_sprite.material.set_shader_parameter("team_index", 1)
	
func update_team_colors() -> void:
	var colors : Array[Color] = []
	for picker in color_pickers:
		colors.append(picker.color)
		
	team.update_palette(colors)
	update_sample_sprite()
	
func update_team_name(new_name: String) -> void:
	team.name = new_name
	
func save_team_resource() -> void:
	var error: Error = ResourceSaver.save(team, "user://saved_teams/" + team.name + ".res")
	#Print for logging errors, should say "OK" if none happened
	print( error_string(error) )
