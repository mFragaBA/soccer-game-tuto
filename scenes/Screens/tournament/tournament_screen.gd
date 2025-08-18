class_name TournamentScreen
extends Screen

const CONFETTI_PREFAB := preload("res://scenes/Screens/tournament/falling_confetti.tscn")
const CONFETTI_AMOUNT := 50

const STAGE_TEXTURES := {
	Tournament.Stage.QUARTER_FINALS: preload("res://assets/assets/art/ui/teamselection/quarters-label.png"),
	Tournament.Stage.SEMI_FINALS: preload("res://assets/assets/art/ui/teamselection/semis-label.png"),
	Tournament.Stage.FINAL: preload("res://assets/assets/art/ui/teamselection/finals-label.png"),
	Tournament.Stage.COMPLETE: preload("res://assets/assets/art/ui/teamselection/winner-label.png"),
}

@onready var flag_containers : Dictionary = {
	Tournament.Stage.QUARTER_FINALS: [%QuarterfinalLeftContainer, %QuarterfinalRightContainer],
	Tournament.Stage.SEMI_FINALS: [%SemifinalLeftContainer, %SemifinalRightContainer],
	Tournament.Stage.FINAL: [%FinalLeftContainer, %FinalRightContainer],
	Tournament.Stage.COMPLETE: [%WinnerContainer],
}

@onready var stage_texture : TextureRect = %StageTexture

var players_country : String = GameManager.player_setup[0]
var tournament : Tournament = null

func _ready() -> void:
	tournament = screen_data.tournament
	refresh_brackets()
	if not tournament.winner.is_empty() and tournament.winner == GameManager.player_setup[0]:
		SoundPlayer.play(SoundPlayer.Sound.CHAMPION)
		
		var screen_size := get_viewport().get_visible_rect().size
		var affine_inverse : Transform2D = get_viewport().get_canvas_transform().affine_inverse()
		for i in range(CONFETTI_AMOUNT):
			var confetti := CONFETTI_PREFAB.instantiate()
			var random_canvas_pos = Vector2(randf_range(0, 1), randf_range(-1, 0)) * screen_size
			confetti.position = affine_inverse * random_canvas_pos
			add_child(confetti)
			
	
func _process(_delta: float) -> void:
	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
		if tournament.current_stage < Tournament.Stage.COMPLETE:
			transition_screen(SoccerGame.ScreenType.IN_GAME, screen_data)
		else:
			transition_screen(SoccerGame.ScreenType.MAIN_MENU, screen_data)
		
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
	
func refresh_brackets() -> void:
	for stage in range(tournament.current_stage + 1):
		refresh_bracket_stage(stage)
	
	stage_texture.texture = STAGE_TEXTURES[tournament.current_stage]
		
func refresh_bracket_stage(stage: Tournament.Stage) -> void:
	var flag_nodes := get_flag_nodes_for_stage(stage)
	
	if stage < Tournament.Stage.COMPLETE:
		var matches : Array = tournament.matches[stage]
		for i in range(matches.size()):
			var home_team_flag : BracketFlag = flag_nodes[2 * i]
			var away_team_flag : BracketFlag = flag_nodes[2 * i + 1]
			home_team_flag.texture = FlagHelper.get_texture(matches[i].team_home)
			away_team_flag.texture = FlagHelper.get_texture(matches[i].team_away)
			if stage < tournament.current_stage:
				var winners_flag := home_team_flag if matches[i].winner == matches[i].team_home else away_team_flag
				var losers_flag := home_team_flag if winners_flag == away_team_flag else away_team_flag
				winners_flag.set_as_winner(matches[i].final_score)
				losers_flag.set_as_loser()
			elif players_country == matches[i].team_home:
				home_team_flag.set_as_current_team()
				GameManager.current_match = matches[i]
			elif players_country == matches[i].team_away:
				away_team_flag.set_as_current_team()
				GameManager.current_match = matches[i]
	else:
		flag_nodes[0].texture = FlagHelper.get_texture(tournament.winner)
	
func get_flag_nodes_for_stage(stage: Tournament.Stage) -> Array[BracketFlag]:
	var flag_nodes : Array[BracketFlag] = []
	
	for container in flag_containers[stage]:
		for node in container.get_children():
			if node is BracketFlag:
				flag_nodes.append(node)
	
	return flag_nodes
