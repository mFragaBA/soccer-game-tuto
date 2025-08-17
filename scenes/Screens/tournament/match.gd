class_name Match

var team_home : String
var team_away : String
var goals_home : int
var goals_away : int
var final_score : String
var winner : String

func _init(team_home: String, team_away: String) -> void:
	self.team_home = team_home
	self.team_away = team_away
	update_match_info()
	
func increase_score(team_scored_on: String) -> void:
	if team_scored_on == team_home:
		goals_home += 1
	else:
		goals_away += 1

	update_match_info()
	
func update_match_info() -> void:
	winner = team_home if goals_home > goals_away else team_away
	final_score = "%d - %d" % [max(goals_home, goals_away), min(goals_home, goals_away)]
	
func is_tied() -> bool:
	return goals_home == goals_away
	
func has_someone_scored() -> bool:
	return goals_home > 0 or goals_away > 0
