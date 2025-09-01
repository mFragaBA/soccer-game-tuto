extends ScrollContainer

var img_size
var countries : Array[String] = []
var child_count : int

func _ready():
	countries = DataLoader.get_countries().slice(1)
	
	# Add Margin left
	var margin_container : MarginContainer = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 5)
	%HBoxContainer.add_child(margin_container)
	
	place_flags()
	# Setup flags
		
	img_size = %HBoxContainer.get_child(1).get_texture().get_size()
	# duplicate first character to set him in front and back of carousel to create the effect
	var first_child = %HBoxContainer.get_child(1)
	# -1 bc of the margin
	child_count = %HBoxContainer.get_child_count() - 1
	var new_last_child = first_child.duplicate()
	%HBoxContainer.add_child(new_last_child)
	
	# Add Margin Right
	var margin_container_right : MarginContainer = MarginContainer.new()
	margin_container_right.add_theme_constant_override("margin_right", 5)
	%HBoxContainer.add_child(margin_container_right)
	
	%HBoxContainer.add_theme_constant_override("separation", 5)


# scroll the scrollcontainer when choosing an item
func roll(prev = 0, next = 0):
	var prev_pos
	var next_pos
	prev_pos = 5 + prev * (img_size.x + 5)
	next_pos = 5 + next * (img_size.x + 5)
	if prev == child_count-1 and next == 0:
		next_pos = 5 + (prev+1) * (img_size.x + 5)
	elif prev == 0 and next == child_count-1:
		prev_pos = 5 + (next+1) * (img_size.x + 5)
	
	self.scroll_horizontal = prev_pos
	var tween = create_tween()
	tween.tween_property(self, "scroll_horizontal", next_pos, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()

func place_flags() -> void:
	for country in countries:
		var flag_texture := TextureRect.new()
		flag_texture.texture = FlagHelper.get_texture(country)
		flag_texture.scale = Vector2(2, 2)
		#flag_texture.z_index = 1
		%HBoxContainer.add_child(flag_texture)
