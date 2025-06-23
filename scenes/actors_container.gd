class_name ActorsContainer
extends Node2D

const PLAYER_PREFAB := preload("res://scenes/Characters/player.tscn")

@export var ball : Ball
@export var goal_home : Goal
@export var goal_away : Goal

@export var team_home : String
@export var team_away : String

@onready var spawns : Node2D = %Spawns

func _ready() -> void:
	spawn_players(team_home, true)
	spawns.scale.x *= -1
	spawn_players(team_away, false)
	
	var player : Player = get_children().filter(func(p): return p is Player)[4]
	player.control_scheme = Player.ControlScheme.P1
	player.set_control_texture()
	
func spawn_players(country: String, is_home: bool) -> void:
	var own_goal := goal_home if is_home else goal_away
	var target_goal := goal_away if is_home else goal_home
	var players := DataLoader.get_squad(country)
	
	for i in players.size():
		var player_position := spawns.get_child(i).global_position as Vector2
		spawn_player(player_position, own_goal, target_goal, players[i], country)
	
func spawn_player(player_position: Vector2, own_goal: Goal, target_goal: Goal, player_data: PlayerResource, player_country: String) -> void:
	var player := PLAYER_PREFAB.instantiate()
	player.initialize(player_position, ball, own_goal, target_goal, player_data, player_country)
	add_child(player)
	
