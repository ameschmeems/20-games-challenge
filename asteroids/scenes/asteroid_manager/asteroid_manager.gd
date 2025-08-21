extends Node2D

@onready var asteroid_scene: PackedScene = preload("res://asteroids/scenes/asteroid/asteroid.tscn")
@onready var player_scene: PackedScene = preload("res://asteroids/scenes/player/asteroids_player.tscn")
@onready var pause_menu_scene: PackedScene = preload("res://common/UI/pause_menu/pause_menu.tscn")
@onready var game_over_scene: PackedScene = preload("res://common/UI/game_over_screen/game_over_screen.tscn")
@onready var screen_size: Vector2 = get_viewport_rect().size

@export var hud: CanvasLayer

var main_menu_scene: PackedScene = load("res://common/UI/game_select_screen/game_select_screen.tscn")
var level: int = 1
var lives: int = 3
var spawn_boundary: int = 120
var num_asteroids: int = 0
var score: int = 0
var score_values: Dictionary = {
	Asteroid.SizeEnum.LARGE: 20,
	Asteroid.SizeEnum.MEDIUM: 50,
	Asteroid.SizeEnum.SMALL: 100
}

func _ready() -> void:
	init_level()
	spawn_player()
	hud.update_score_display(score)
	hud.update_lives_display(lives)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.current_scene = get_tree().current_scene.scene_file_path
		pause_menu_instance.main_menu_scene = main_menu_scene

func spawn_asteroid(size: Asteroid.SizeEnum, pos: Vector2):
	num_asteroids += 1
	var asteroid_instance: Asteroid = asteroid_scene.instantiate()
	asteroid_instance.size = size
	asteroid_instance.global_position = pos
	asteroid_instance.asteroid_hit.connect(on_asteroid_hit)
	call_deferred("add_child", asteroid_instance)

func init_level():
	for i in level:
		var x_pos1 = randf_range(0, spawn_boundary)
		var x_pos2 = randf_range(screen_size.x - spawn_boundary, screen_size.x)
		var x_pos = [x_pos1, x_pos2].pick_random()
		var y_pos = randf_range(0, screen_size.y)
		spawn_asteroid(Asteroid.SizeEnum.LARGE, Vector2(x_pos, y_pos))
	level += 1

func spawn_player():
	var player_instance = player_scene.instantiate()
	player_instance.global_position = screen_size / 2
	player_instance.player_died.connect(on_player_died)
	call_deferred("add_child", player_instance)

func on_player_died():
	lives -= 1
	hud.update_lives_display(lives)
	if lives == 0:
		var game_over_instance = game_over_scene.instantiate()
		game_over_instance.current_scene = get_tree().current_scene.scene_file_path
		game_over_instance.main_menu_scene = main_menu_scene
		add_child(game_over_instance)
		return
	spawn_player()

func on_asteroid_hit(size: Asteroid.SizeEnum, pos: Vector2):
	num_asteroids -= 1
	if size == Asteroid.SizeEnum.LARGE:
		spawn_asteroid(Asteroid.SizeEnum.MEDIUM, pos)
		spawn_asteroid(Asteroid.SizeEnum.MEDIUM, pos)
	elif size == Asteroid.SizeEnum.MEDIUM:
		spawn_asteroid(Asteroid.SizeEnum.SMALL, pos)
		spawn_asteroid(Asteroid.SizeEnum.SMALL, pos)
	score += score_values[size]
	hud.update_score_display(score)
	if num_asteroids == 0:
		init_level()
