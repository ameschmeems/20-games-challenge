extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size
@onready var projectile_scene: PackedScene = preload("res://asteroids/scenes/projectile/asteroids_projectile.tscn")
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var thrust_particles = $ThrustParticles
@onready var explosion_particles = $ExplosionParticles
@onready var invuln_timer = $InvulnTimer
@onready var collision_shape = $CollisionShape2D

@export var rotate_speed: float = 3
@export var max_speed: float = 350
@export var speed_slowdown: float = 3

var direction = Vector2.UP
var projectile_offset: Vector2 = Vector2(0, -40)

signal player_died

func _ready() -> void:
	await invuln_timer.timeout
	collision_shape.disabled = false

func _physics_process(delta: float) -> void:
	var rot_direction = Input.get_axis("move_left", "move_right")
	rotate(rot_direction * delta * rotate_speed)
	direction = Vector2.UP.rotated(rotation)
	if Input.is_action_pressed("move_up"):
		velocity += 10 * direction
		velocity = velocity.limit_length(max_speed)
		anim.play("thrust")
		thrust_particles.emitting = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed_slowdown)
		anim.play("idle")
		thrust_particles.emitting = false
	if Input.is_action_just_pressed("shoot"):
		var projectile_instance = projectile_scene.instantiate()
		projectile_instance.direction = direction
		projectile_instance.rotation = rotation
		projectile_instance.global_position = global_position + projectile_offset.rotated(rotation)
		get_tree().current_scene.add_child(projectile_instance)
	screen_wrap()
	move_and_slide()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)

func die():
	collision_shape.set_deferred("disabled", true)
	explosion_particles.set_deferred("emitting", true)
	anim.visible = false
	velocity = Vector2.ZERO
	await explosion_particles.finished
	player_died.emit()
	queue_free()
