extends Node

@onready var asteroid_scene = preload("res://asteroids/scenes/asteroid/asteroid.tscn")

func _ready() -> void:
	spawn_asteroid(Asteroid.SizeEnum.LARGE, Vector2(120, 120))

func spawn_asteroid(size: Asteroid.SizeEnum, pos: Vector2):
	var asteroid_instance: Asteroid = asteroid_scene.instantiate()
	asteroid_instance.size = size
	asteroid_instance.global_position = pos
	asteroid_instance.asteroid_hit.connect(on_asteroid_hit)
	call_deferred("add_child", asteroid_instance)

func on_asteroid_hit(size: Asteroid.SizeEnum, pos: Vector2):
	if size == Asteroid.SizeEnum.LARGE:
		spawn_asteroid(Asteroid.SizeEnum.MEDIUM, pos)
		spawn_asteroid(Asteroid.SizeEnum.MEDIUM, pos)
	elif size == Asteroid.SizeEnum.MEDIUM:
		spawn_asteroid(Asteroid.SizeEnum.SMALL, pos)
		spawn_asteroid(Asteroid.SizeEnum.SMALL, pos)
