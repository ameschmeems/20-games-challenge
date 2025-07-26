extends Node

@onready var player: CharacterBody2D = $"../Frog"
@onready var frog_scene: PackedScene = preload("res://frogger/scenes/frog/frog.tscn")

@export var spawn_point: Vector2

var lives: int = 3

func kill_player():
	player.die()
	lives -= 1
	print("lives: " + str(lives))
	if lives > 0:
		print("instantiating")
		player = frog_scene.instantiate()
		player.set_deferred("global_position", spawn_point)
		get_parent().call_deferred("add_child", player)
