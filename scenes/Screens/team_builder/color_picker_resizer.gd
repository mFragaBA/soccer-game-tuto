class_name ColorPickerBtn
extends Button

@onready var edit_team_screen : TeamBuilderEditTeamScreen = $"../../../../../.."
@onready var selector_panel_containers : Node = %SelectorPanelContainers
@export var color_rect : ColorRect
@export var color_selector : ColorSelector

var color : Color

func init(color: Color) -> void:
	color_rect.color = color
	color_selector.color = color
	self.color = color
	
func _ready() -> void:
	color_selector.color_changed.connect(_on_color_changed.bind())
	pressed.connect(_on_button_pressed.bind())
	
func _on_color_changed(new_color: Color) -> void:
	color_rect.color = new_color
	color = new_color
	edit_team_screen.update_team_colors()
	
func _on_button_pressed() -> void:
	var is_visible : bool = color_selector.get_parent().visible
	
	for selector_panel in selector_panel_containers.get_children():
		selector_panel.visible = false
				
	color_selector.get_parent().visible = !is_visible
	
	selector_panel_containers.visible = !is_visible
