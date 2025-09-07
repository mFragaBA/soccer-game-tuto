class_name CarouselSelector
extends ScrollContainer

@export var side_margin : float
@export var element_separation: float

var elem_size
var countries : Array[String] = []
var child_count : int
var is_selected : bool = false

func initialize(element_textures: Array[TextureRect]):
	countries = DataLoader.get_countries().slice(1)
	
	# Add Margin left
	var margin_container : MarginContainer = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", side_margin)
	%HBoxContainer.add_child(margin_container)
	
	place_elements(element_textures)
	# Setup flags
		
	elem_size = element_textures[0].get_size()
	# duplicate first character to set him in front and back of carousel to create the effect
	var first_child = %HBoxContainer.get_child(1)
	# -1 bc of the margin
	child_count = %HBoxContainer.get_child_count() - 1
	var new_last_child = first_child.duplicate()
	%HBoxContainer.add_child(new_last_child)
	
	# Add Margin Right
	var margin_container_right : MarginContainer = MarginContainer.new()
	margin_container_right.add_theme_constant_override("margin_right", side_margin)
	%HBoxContainer.add_child(margin_container_right)
	
	%HBoxContainer.add_theme_constant_override("separation", element_separation)
	
	# To set initial position
	roll(0, 0)

# scroll the scrollcontainer when choosing an item
func roll(prev = 0, next = 0):
	var prev_pos
	var next_pos
	prev_pos = side_margin + prev * (elem_size.x + element_separation)
	next_pos = side_margin + next * (elem_size.x + element_separation)
	if prev == child_count-1 and next == 0:
		next_pos = side_margin + (prev+1) * (elem_size.x + element_separation)
	elif prev == 0 and next == child_count-1:
		prev_pos = side_margin + (next+1) * (elem_size.x + element_separation)
	
	self.scroll_horizontal = prev_pos
	var tween = create_tween()
	tween.tween_property(self, "scroll_horizontal", next_pos, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.play()

func place_elements(elements: Array[TextureRect]) -> void:
	for element in elements:
		%HBoxContainer.add_child(element)
