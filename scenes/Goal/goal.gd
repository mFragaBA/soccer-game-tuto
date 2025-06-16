class_name Goal
extends Node2D

@onready var backnet_area : Area2D = %BacknetArea

func _ready() -> void:
	backnet_area.body_entered.connect(on_ball_enter_back_net.bind())
	
func on_ball_enter_back_net(ball: Ball) -> void:
	ball.stop()
