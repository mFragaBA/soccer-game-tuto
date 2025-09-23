class_name ColorPickerResizer
extends ColorPickerButton

@onready var edit_team_screen : TeamBuilderEditTeamScreen = $"../.."

func _ready() -> void:
	var popup = get_popup()
	popup.max_size = Vector2(100, 100)
	popup.content_scale_size = Vector2(1000, 1000)
	popup.content_scale_factor = 3
	popup.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	
	var picker = get_picker()
	picker.color_changed.connect(_on_color_changed.bind())
	
func _on_color_changed(new_color: Color) -> void:
	var stylebox: StyleBox = StyleBoxFlat.new()
	stylebox.bg_color = new_color
	add_theme_stylebox_override("normal", stylebox)
	edit_team_screen.update_team_colors()
