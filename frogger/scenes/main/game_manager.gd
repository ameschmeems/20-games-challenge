extends Node

@onready var player: CharacterBody2D = $"../Frog"
@onready var waters_node: Node = $"../LilypadLane/Waters"
@onready var frog_scene: PackedScene = preload("res://frogger/scenes/frog/frog.tscn")

@export var spawn_point: Vector2

var lives: int = 3

var lilypads: int = 5

func _ready() -> void:
	var waters = waters_node.get_children()
	for water in waters:
		water.body_entered.connect(on_water_body_entered)

func kill_player():
	player.die()
	lives -= 1
	print("lives: " + str(lives))
	if lives > 0:
		player = frog_scene.instantiate()
		player.set_deferred("global_position", spawn_point)
		get_parent().call_deferred("add_child", player)

func lilypad_done():
	lilypads -= 1
	if lilypads <= 0:
		print("You won!")
		return
	player.queue_free()
	player = frog_scene.instantiate()
	player.set_deferred("global_position", spawn_point)
	get_parent().call_deferred("add_child", player)
	

func on_water_body_entered(_body):
	kill_player()
