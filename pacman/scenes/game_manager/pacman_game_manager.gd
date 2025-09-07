extends Node

var score: int = 0
var lives: int = 3
var pellets_left: int = 0
var main_menu_scene: PackedScene = load("res://common/UI/game_select_screen/game_select_screen.tscn")

@onready var pause_menu_scene: PackedScene = preload("res://common/UI/pause_menu/pause_menu.tscn")
@onready var win_screen_scene: PackedScene = preload("res://common/UI/win_screen/win_screen.tscn")
@onready var game_over_scene: PackedScene = preload("res://common/UI/game_over_screen/game_over_screen.tscn")

@export var hud: CanvasLayer
@export var player: PacmanPlayer
@export var pellets_node: Node2D
@export var player_start_pos: Vector2 = Vector2(0.0, 229.0)

func _ready() -> void:
	hud.update_score_display(score)
	hud.update_lives_display(lives)
	player.player_died.connect(on_player_died)
	for pellet in pellets_node.get_children():
		pellets_left += 1
		if pellet is Pellet:
			pellet.pellet_collected.connect(on_pellet_collected)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.current_scene = get_tree().current_scene.scene_file_path
		pause_menu_instance.main_menu_scene = main_menu_scene

func on_pellet_collected() -> void:
	score += 10
	pellets_left -= 1
	hud.update_score_display(score)

func on_player_died() -> void:
	get_tree().paused = true
	await player.anim.animation_finished
	lives -= 1
	if lives == 0:
		var game_over_instance = game_over_scene.instantiate()
		game_over_instance.current_scene = get_tree().current_scene.scene_file_path
		game_over_instance.main_menu_scene = main_menu_scene
		add_child(game_over_instance)
		return
	hud.update_lives_display(lives)
	get_tree().paused = false
	player.anim.play("default")
	player.global_position = player_start_pos
	player.dying = false
