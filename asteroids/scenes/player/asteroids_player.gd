extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size
@onready var projectile_scene: PackedScene = preload("res://asteroids/scenes/projectile/asteroids_projectile.tscn")

@export var rotate_speed: float = 3
@export var max_speed: float = 350
@export var speed_slowdown: float = 3

var direction = Vector2.UP

signal player_died

func _physics_process(delta: float) -> void:
	var rot_direction = Input.get_axis("move_left", "move_right")
	rotate(rot_direction * delta * rotate_speed)
	direction = Vector2.UP.rotated(rotation)
	if Input.is_action_pressed("move_up"):
		velocity += 10 * direction
		velocity = velocity.limit_length(max_speed)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed_slowdown)
	if Input.is_action_just_pressed("shoot"):
		var projectile_instance = projectile_scene.instantiate()
		projectile_instance.direction = direction
		projectile_instance.rotation = rotation
		projectile_instance.global_position = global_position
		get_tree().current_scene.add_child(projectile_instance)
	screen_wrap()
	move_and_slide()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)

func die():
	player_died.emit()
	queue_free()

