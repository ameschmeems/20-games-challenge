extends Node

@export var brick_scene: PackedScene

signal points_scored(points: int)
signal screen_cleared

const SCREEN_WIDTH = 1280
const SCREEN_HEIGHT = 720

var bricks_per_row = 8
var num_rows = 4
var x_start_offset = 250
var x_offset = (SCREEN_WIDTH - 2 * x_start_offset) / (bricks_per_row - 1)
var y_offset = 60
var num_bricks = 0

func _ready() -> void:
	init_bricks()

func init_bricks() -> void:
	for row in range(num_rows):
		for col in range(bricks_per_row):
			var brick_instance = brick_scene.instantiate()
			brick_instance.global_position = Vector2(x_start_offset + x_offset * col, y_offset * (row + 1))
			brick_instance.deleted.connect(on_brick_deleted)
			add_child(brick_instance)
			num_bricks += 1

func emit_points_scored(points: int):
	points_scored.emit(points)

func emit_screen_cleared():
	screen_cleared.emit()

func on_brick_deleted():
	num_bricks -= 1
	if num_bricks == 0:
		emit_screen_cleared()
		init_bricks()
	emit_points_scored(100)