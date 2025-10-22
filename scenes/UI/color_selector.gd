class_name ColorSelector
extends GridContainer

const SWATCH_PREFAB := preload("res://scenes/UI/color_swatch.tscn")

const COLORS := [
"#000000",
"#000080",
"#004080",
"#7092be",
"#99d9ea",
"#9fffff",
"#ffffff",
"#004040",
"#008040",
"#22b14c",
"#b5e61d",
"#ffff80",
"#000040",
"#2c2d54",
"#3f48cc",
"#8080c0",
"#c8bfe7",
"#00a2e8",
"#80ff80",
"#400040",
"#a349a4",
"#ff8080",
"#ffaec9",
"#400000",
"#880015",
"#ed1c24",
"#ff8040",
"#ffe176",
"#800080",
"#ff0080",
"#804040",
"#b97a57",
"#ffb164",
"#400080",
"#efe4b0",
"#7f7f7f",
]

signal color_changed(color: Color)

var color : Color = Color.WHITE

func _ready() -> void:
	for color in COLORS:
		var swatch : ColorSwatch = SWATCH_PREFAB.instantiate()
		swatch.set_color(color)
		swatch.pressed.connect(_on_color_picked.bind(swatch))
		add_child(swatch)
				
func _on_color_picked(swatch: ColorSwatch) -> void:
	color = swatch.get_color()
	color_changed.emit(color)
