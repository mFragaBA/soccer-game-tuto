class_name ActorsContainer
extends Node2D

const DURATION_WEIGHT_CACHE := 200
const PLAYER_PREFAB := preload("res://scenes/Characters/player.tscn")

@export var ball : Ball
@export var goal_home : Goal
@export var goal_away : Goal

@onready var spawns : Node2D = %Spawns
@onready var kickoffs : Node2D = %KickOffs

var squad_home : Array[Player] = []
var squad_away : Array[Player] = []
var time_since_last_cache_refresh := Time.get_ticks_msec()

func _ready() -> void:
	var home_country := GameManager.get_home_country()
	var away_country := GameManager.get_away_country()
	squad_home = spawn_players(home_country, true)
	
	spawns.scale.x *= -1
	kickoffs.scale.x *= -1
	
	squad_away = spawn_players(away_country, false)
	
	setup_control_schemes()
	
	goal_home.initialize(home_country)
	goal_away.initialize(away_country)
	
func _process(_delta: float) -> void:
	if (Time.get_ticks_msec() - time_since_last_cache_refresh) > DURATION_WEIGHT_CACHE:
		time_since_last_cache_refresh = Time.get_ticks_msec()
		set_on_duty_weights()
	
func spawn_players(country: String, is_home: bool) -> Array[Player]:
	var player_nodes : Array[Player] = []
	var own_goal := goal_home if is_home else goal_away
	var target_goal := goal_away if is_home else goal_home
	var players := DataLoader.get_squad(country)
	
	for i in players.size():
		var player_position := spawns.get_child(i).global_position as Vector2
		var kickoff_position := player_position if i < 4 else kickoffs.get_child(i - 4).global_position as Vector2
		
		var player = spawn_player(player_position, kickoff_position, own_goal, target_goal, players[i], country)
		player_nodes.append(player)
		add_child(player)
	
	return player_nodes
	
func spawn_player(player_position: Vector2, kickoff_position: Vector2, own_goal: Goal, target_goal: Goal, player_data: PlayerResource, player_country: String) -> Player:
	var player := PLAYER_PREFAB.instantiate()
	player.initialize(player_position, kickoff_position, ball, own_goal, target_goal, player_data, player_country)
	
	player.swap_requested.connect(on_player_swap_request.bind())
	
	return player
	
func set_on_duty_weights() -> void:
	for squad in [squad_home, squad_away]:
		var cpu_players : Array[Player] = squad.filter(func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALIE)
		cpu_players.sort_custom(func(p1: Player, p2: Player):
			return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position)
		)
		
		for i in range(cpu_players.size()):
			# Divide by 10 to fit into [0, 1] range
			cpu_players[i].weight_on_duty_steering = 1 - ease(float(i) / 10.0, 0.1)

func setup_control_schemes() -> void:
	var p1_country := GameManager.player_setup[0]
	
	if GameManager.is_single_player():
		var player_squad := squad_home if squad_home[0].country == p1_country else squad_away
		player_squad[4].set_control_scheme(Player.ControlScheme.P1)
	elif GameManager.is_coop():
		var player_squad := squad_home if squad_home[0].country == p1_country else squad_away
		player_squad[4].set_control_scheme(Player.ControlScheme.P1)
		player_squad[5].set_control_scheme(Player.ControlScheme.P2)
	else:
		var p1_squad := squad_home if squad_home[0].country == p1_country else squad_away
		p1_squad[4].set_control_scheme(Player.ControlScheme.P1)
		var p2_squad := squad_home if p1_squad == squad_away else squad_away
		p2_squad[4].set_control_scheme(Player.ControlScheme.P2)
	
	var player : Player = get_children().filter(func(p): return p is Player)[4]
	player.set_control_scheme(Player.ControlScheme.P1)

func on_player_swap_request(requesting_player: Player) -> void:
	var squad := squad_home if requesting_player.country == squad_home[0].country else squad_away
	var cpu_players : Array[Player] = squad.filter(func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALIE)
	cpu_players.sort_custom(func(p1: Player, p2: Player):
		return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position)
	)
	
	var closest_cpu_to_ball := cpu_players[0]
	if closest_cpu_to_ball.position.distance_squared_to(ball.position) < requesting_player.position.distance_squared_to(ball.position):
		var player_control_scheme := requesting_player.control_scheme
		requesting_player.set_control_scheme(Player.ControlScheme.CPU)
		closest_cpu_to_ball.set_control_scheme(player_control_scheme)
