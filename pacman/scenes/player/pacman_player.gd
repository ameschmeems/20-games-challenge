extends CharacterBody2D
class_name PacmanPlayer

@export var speed: float = 250.0

var next_movement_direction: Vector2 = Vector2.ZERO
var next_rotation: float = 0.0
var movement_direction: Vector2 = Vector2.ZERO
var shape_query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	shape_query.shape = collision_shape.shape
	shape_query.collision_mask = 1

func _physics_process(delta: float) -> void:
	get_input()

	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction
	if can_move_in_direction(next_movement_direction, delta):
		movement_direction = next_movement_direction
		rotation_degrees = next_rotation

	velocity = movement_direction * speed
	move_and_slide()

func get_input() -> void:
	if Input.is_action_pressed("move_left"):
		next_movement_direction = Vector2.LEFT
		next_rotation = 0
	elif Input.is_action_pressed("move_right"):
		next_movement_direction = Vector2.RIGHT
		next_rotation = 180
	elif Input.is_action_pressed("move_down"):
		next_movement_direction = Vector2.DOWN
		next_rotation = 270
	elif Input.is_action_pressed("move_up"):
		next_movement_direction = Vector2.UP
		next_rotation = 90

func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 3)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0