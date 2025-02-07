extends CharacterBody2D

@export var starting_speed: float = 300

var speed = 0
var ball_direction: Vector2
var start_directions: Array[Vector2] = [
	Vector2(1, -1).normalized(),
	Vector2(-1, -1).normalized()
]
var speed_increase = 20

func _ready() -> void:
	speed = starting_speed
	ball_direction = start_directions.pick_random().rotated(randf_range(0, PI/6))

func _physics_process(delta: float) -> void:
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
		speed += speed_increase
