extends CharacterBody2D

signal ball_dropped

const SCREEN_HEIGHT = 720

@export var starting_speed: float = 300

@onready var ball_radius = $CollisionShape2D.shape.radius

var speed = 0
var ball_direction: Vector2
var start_directions: Array[Vector2] = [
	Vector2(1, -1).normalized(),
	Vector2(-1, -1).normalized()
]
var speed_increase = 15

func _ready() -> void:
	ball_direction = start_directions.pick_random().rotated(randf_range(0, PI/6))

func _physics_process(delta: float) -> void:
	if global_position.y > SCREEN_HEIGHT + ball_radius:
		emit_ball_dropped()
		queue_free()
	
	var collision = move_and_collide(ball_direction * speed * delta)
	if !collision:
		return
	var collider: Node = collision.get_collider()
	if collider && collider.is_in_group("paddle"):
		ball_direction = (global_position - collider.global_position) * 0.5 + ball_direction.bounce(collision.get_normal()) * 0.5
		ball_direction = ball_direction.normalized()
	else:
		ball_direction = ball_direction.bounce(collision.get_normal()).normalized()

	if collider && collider.has_method("hit"):
		collider.hit()
		if speed != 0:
			speed += speed_increase

func emit_ball_dropped():
	ball_dropped.emit()
