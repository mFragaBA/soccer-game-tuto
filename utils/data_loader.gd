extends Node

const DEFAULT_PALETTE : Array[Color] = [
	Color("#D95763"),
	Color("#AC3232"),
	Color("#5FCDE4"),
	Color("#639BFF"),
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
			
		var team_resource := TeamResource.new(country_name, parsed_players, team_palette)
		squads.get_or_add(country_name, team_resource)
		
		assert(players.size() == 6)
	
	# For each team saved as a resource load it
	for path in get_all_file_paths("user://saved_teams"):
		var team : TeamResource = ResourceLoader.load(path)
		countries.append(team.name)
		squads.get_or_add(team.name, team)
	
	json_file.close()
	
func get_squad(country: String) -> TeamResource:
	assert(squads.has(country), "requested team not in squads Dictionary")
	return squads.get(country)

func get_countries() -> Array[String]:
	return countries

func get_all_file_paths(path: String) -> Array[String]:  
		var file_paths: Array[String] = []  
		var dir = DirAccess.open(path)  
		
		if !dir:
			DirAccess.make_dir_recursive_absolute(path)
			dir = DirAccess.open(path)
		
		dir.list_dir_begin()  
		var file_name = dir.get_next()  
		while file_name != "":  
			var file_path = path + "/" + file_name  
			if dir.current_is_dir():  
				file_paths += get_all_file_paths(file_path)  
			else:  
				file_paths.append(file_path)  
			file_name = dir.get_next()  
		return file_paths
