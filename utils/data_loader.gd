extends Node

const DEFAULT_PALETTE : Array[Color] = [
	Color("#D95763"),
	Color("#AC3232"),
	Color("#5FCCE3"),
	Color("#639AFE"),
	Color("#322B28"),
	Color("#221C1A"),
]

var countries : Array[String] = ["DEFAULT"]

# Dictionary mapping string to PlayerResource array
var squads : Dictionary

func _init() -> void:
	var json_file := FileAccess.open("res://assets/assets/json/squads.json", FileAccess.READ)
	if json_file == null:
		printerr("Json File not found")
		
	var json_text := json_file.get_as_text()
	var json := JSON.new()
	if json.parse(json_text) != OK:
		printerr("Couldn't parse json file: L" + str(json.get_error_line()) + ": " + json.get_error_message())

	for team in json.data:
		var country_name := team["country"] as String
		var players := team["players"] as Array
		
		# for now a single palette consisting of 6 colors, then we add the possibility of more
		var team_palette := DEFAULT_PALETTE 
		
		if team.has("palette"):
			team_palette = []
			for palette_color in team["palette"] as Array:
				team_palette.append(Color(palette_color) )
		
		var parsed_players : Array[PlayerResource] = []
		
		countries.append(country_name)
		
		for player in players:
			var player_name := player["name"] as String
			var skin := player["skin"] as Player.SkinColor
			var role := player["role"] as Player.Role
			var speed := player["speed"] as float
			var power := player["power"] as float
			
			var player_resource := PlayerResource.new(player_name, skin, role, speed, power)
			
			parsed_players.append(player_resource)
			
		var team_resource := TeamResource.new(parsed_players, team_palette)
		squads.get_or_add(country_name, team_resource)
		
		assert(players.size() == 6)
	
	json_file.close()
	
func get_squad(country: String) -> TeamResource:
	assert(squads.has(country), "requested team not in squads Dictionary")
	return squads.get(country)

func get_countries() -> Array[String]:
	return countries
