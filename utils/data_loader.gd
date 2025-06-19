extends Node

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
		
		squads.get_or_add(country_name, [])
		
		for player in players:
			var player_name := player["name"] as String
			var skin := player["skin"] as Player.SkinColor
			var role := player["role"] as Player.Role
			var speed := player["speed"] as float
			var power := player["power"] as float
			
			var player_resource := PlayerResource.new(player_name, skin, role, speed, power)
			
			squads.get(country_name).append(player_resource)
		
		assert(players.size() == 6)
	
	json_file.close()
	
func get_squad(country: String) -> Array:
	return squads.get(country, [])
