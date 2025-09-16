@tool
extends EditorScript

@export var tex : Texture2D = preload("res://assets/assets/art/palettes/teams-color-palette-own.png")

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var image := tex.get_image()
		
	for y in range(image.get_height()):
		var color_palette_array := []
		for x in range(image.get_width()):
			var col := image.get_pixel(x, y)
			
			color_palette_array.append("#" + col.to_html(false).to_upper())

		print(color_palette_array)
