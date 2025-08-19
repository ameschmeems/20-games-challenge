extends Node2D

@onready var asteroid_scene = preload("res://asteroids/scenes/asteroid/asteroid.tscn")
@onready var player_scene = preload("res://asteroids/scenes/player/asteroids_player.tscn")
@onready var screen_size = get_viewport_rect().size

var level: int = 1
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
	pass

func on_asteroid_hit(size: Asteroid.SizeEnum, pos: Vector2):
	num_asteroids -= 1
	if size == Asteroid.SizeEnum.LARGE:
		spawn_asteroid(Asteroid.SizeEnum.MEDIUM, pos)
		spawn_asteroid(Asteroid.SizeEnum.MEDIUM, pos)
	elif size == Asteroid.SizeEnum.MEDIUM:
		spawn_asteroid(Asteroid.SizeEnum.SMALL, pos)
		spawn_asteroid(Asteroid.SizeEnum.SMALL, pos)
	score += score_values[size]
	print(score)
	if num_asteroids == 0:
		init_level()
