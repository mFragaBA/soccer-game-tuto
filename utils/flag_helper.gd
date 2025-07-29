class_name FlagHelper

static var flag_textures : Dictionary = {}

static func get_texture(country: String) -> Texture2D:
	return flag_textures.get_or_add(country, load("res://assets/assets/art/ui/flags/flag-%s.png" % [country.to_lower()]))
