extends Area2D

@onready var screen_size = get_viewport_rect().size

var direction: Vector2 = Vector2.UP
var speed = 450

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	screen_wrap()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)
