class_name ColorSwatch
extends Button

@onready var color_rect : ColorRect = %ColorRect
var color := Color.WHITE

func _ready() -> void:
	color_rect.color = color

func set_color(new_color: Color) -> void:
	color = new_color

func get_color() -> Color:
	return color
