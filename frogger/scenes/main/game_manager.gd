extends Node

@onready var player: CharacterBody2D = $"../Frog"
@onready var waters_node: Node = $"../LilypadLane/Waters"
@onready var hud: Node = $"../FroggerHUD"
@onready var frog_scene: PackedScene = preload("res://frogger/scenes/frog/frog.tscn")

@export var spawn_point: Vector2
@export var pause_menu_scene: PackedScene
@export var game_over_scene: PackedScene
@export var win_screen_scene: PackedScene

var main_menu_scene = load("res://common/UI/game_select_screen/game_select_screen.tscn")

var lives: int = 3

var lilypads: int = 5

func _ready() -> void:
	var waters = waters_node.get_children()
	hud.update_lives_display(lives)
	for water in waters:
		water.body_entered.connect(on_water_body_entered)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.current_scene = get_tree().current_scene.scene_file_path
		pause_menu_instance.main_menu_scene = main_menu_scene

func kill_player():
	player.die()
	lives -= 1
	hud.update_lives_display(lives)
	if lives > 0:
		player = frog_scene.instantiate()
		player.set_deferred("global_position", spawn_point)
		get_parent().call_deferred("add_child", player)
	else:
		var game_over_instance = game_over_scene.instantiate()
		add_child(game_over_instance)
		game_over_instance.current_scene = get_tree().current_scene.scene_file_path
		game_over_instance.main_menu_scene = main_menu_scene

func lilypad_done():
	lilypads -= 1
	player.queue_free()
	if lilypads <= 0:
		var win_screen_instance = win_screen_scene.instantiate()
		add_child(win_screen_instance)
		win_screen_instance.current_scene = get_tree().current_scene.scene_file_path
		win_screen_instance.main_menu_scene = main_menu_scene
		return
	player = frog_scene.instantiate()
	player.set_deferred("global_position", spawn_point)
	get_parent().call_deferred("add_child", player)
	

func on_water_body_entered(_body):
	print("Water body entered!")
	kill_player()
