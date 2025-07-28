extends Node2D

const SCREEN_WIDTH: int = 1280
const TILE_SIZE: int = 64
const LOG_TILES: int = 3

@export var log_scene: PackedScene
@export var water_scene: PackedScene
@export var speed: int = 50
@export var direction: Vector2 = Vector2.RIGHT
@export var x_boundary: int = 768

var log_amount: int = 3
var objects = []

signal player_drowned

func _ready() -> void:
	var water_tiles_between_logs: int = (SCREEN_WIDTH - TILE_SIZE * LOG_TILES * log_amount) / ((log_amount - 1) * TILE_SIZE)

	for i in log_amount:
		var log_instance: Area2D = log_scene.instantiate()
		log_instance.position = Vector2(-x_boundary, 0) + water_tiles_between_logs * TILE_SIZE * i * direction + TILE_SIZE * i * LOG_TILES * direction
		log_instance.body_entered.connect(on_log_body_entered)
		log_instance.body_exited.connect(on_log_body_exited)
		add_child(log_instance)
		objects.append(log_instance)
		for j in water_tiles_between_logs:
			var water: Area2D = water_scene.instantiate()
			water.position = log_instance.position + TILE_SIZE * (j + 2) * direction
			water.body_entered.connect(on_water_body_entered)
			add_child(water)
			objects.append(water)

func _physics_process(delta: float) -> void:
	for object in objects:
		var new_position = speed * delta * direction + object.position
		if abs(new_position.x - x_boundary) < 10 && !object.is_in_group("player"):
			object.position.x = -x_boundary
		else:
			object.position = new_position

func on_log_body_entered(body):
	objects.append(body)

func on_log_body_exited(_body):
	objects.pop_back()

func on_water_body_entered(_body):
	player_drowned.emit()
