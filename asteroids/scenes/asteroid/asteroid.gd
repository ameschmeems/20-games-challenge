extends Area2D
class_name Asteroid

@onready var screen_size = get_viewport_rect().size

var direction: Vector2 = Vector2.UP
var speed: float = 125
var size: SizeEnum = SizeEnum.LARGE
var size_scale_values: Dictionary = {
	SizeEnum.LARGE : 1.0,
	SizeEnum.MEDIUM : 0.75,
	SizeEnum.SMALL : 0.5
}

enum SizeEnum { LARGE, MEDIUM, SMALL }

signal asteroid_hit(size: SizeEnum, pos: Vector2)

func _ready() -> void:
	rotation = randf_range(0, 2*PI)
	direction = direction.rotated(rotation)
	speed = randf_range(100, 150)
	scale *= size_scale_values[size]
	body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	screen_wrap()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)

func hit():
	asteroid_hit.emit(size, global_position)
	queue_free()

func on_body_entered(body: CharacterBody2D):
	body.die()
