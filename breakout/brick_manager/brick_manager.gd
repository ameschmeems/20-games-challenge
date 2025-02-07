extends Node

@export var brick_scene: PackedScene

const SCREEN_WIDTH = 1280
const SCREEN_HEIGHT = 720

var bricks_per_row = 8
var num_rows = 4
var x_start_offset = 250
var x_offset = (SCREEN_WIDTH - 2 * x_start_offset) / (bricks_per_row - 1)
var y_offset = 60

func _ready() -> void:
	init_bricks()

func init_bricks() -> void:
	for row in range(num_rows):
		for col in range(bricks_per_row):
			var brick_instance = brick_scene.instantiate()
			brick_instance.global_position = Vector2(x_start_offset + x_offset * col, y_offset * (row + 1))
			add_child(brick_instance)
