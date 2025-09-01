class_name TournamentBuilder

var playing_teams : Array[String] = []
var number_of_teams := 8

func build() -> Tournament:
	var n_remaining_teams := number_of_teams - playing_teams.size()
	
	var team_pool : Array[String] = DataLoader.get_countries().slice(1)
	team_pool = team_pool.filter(func (team: String): return team not in playing_teams)
	team_pool.shuffle()
	var remaining_teams := team_pool.slice(0, n_remaining_teams)
	
	return Tournament.new(playing_teams + remaining_teams)

func with_team(team: String) -> TournamentBuilder:
	assert(team not in playing_teams, "team already included in tournament")
	
	playing_teams.append(team)
	
	assert(playing_teams.size() < 32, "More than 32 teams per tournament not supported")
	return self

func with_teams(teams: Array[String]) -> TournamentBuilder:
	for team in teams:
		self.with_team(team)
		
	return self
	
func with_amount_of_teams(n_teams: int) -> TournamentBuilder:
	number_of_teams = nearest_po2(n_teams)
	return self
