extends CharacterBody2D

signal scored_goal(pos: Vector2)

@export var speed: float = 300
@export var acceleration: float = 25

@onready var ball_radius = $CollisionShape2D.shape.radius

var ball_direction: Vector2 = Vector2.RIGHT
var start_directions: Array[Vector2] = [
	Vector2(1,1).normalized(),
	Vector2(-1,1).normalized(),
	Vector2(1,-1).normalized(),
	Vector2(-1,-1).normalized()
]

func _ready() -> void:
	ball_direction = start_directions.pick_random().rotated(randf_range(0, PI/6))

func _physics_process(delta: float) -> void:
	if global_position.x <= 0 || global_position.x >= 1280:
		emit_scored_goal()
		queue_free()
		return

	speed += acceleration * delta
	
	var collision = move_and_collide(ball_direction * speed * delta)
	if !collision:
		return
	var parent = get_parent()
	if parent.has_method("bounce_sfx_play"):
		parent.bounce_sfx_play()
	ball_direction = ball_direction.bounce(collision.get_normal())

func emit_scored_goal():
	scored_goal.emit(global_position)
