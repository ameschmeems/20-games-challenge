extends CharacterBody2D

const TILE_SIZE: int = 64
const HOP_TIME_SEC: float = 0.2

var is_moving: bool = false

@onready var game_manager = $"../GameManager"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	rotation = Vector2.UP.angle()

func _process(_delta: float) -> void:
	if global_position.x < 0 || global_position.x > 1280:
		game_manager.kill_player()

func _input(_event: InputEvent) -> void:

	if is_moving:
		return

	if Input.is_action_just_pressed("move_left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("move_right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("move_up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("move_down"):
		move(Vector2.DOWN)

func move(direction: Vector2):
	var destination: Vector2 = global_position + direction * TILE_SIZE

	if destination.y > 768:
		return

	is_moving = true
	rotation = direction.angle()
	var tween = self.create_tween()

	tween.tween_property(self, "global_position", destination, HOP_TIME_SEC).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
	animated_sprite.play("jump")
	await tween.finished
	animated_sprite.play("idle")
	is_moving = false

func entered_lilypad(destination: Vector2):
	is_moving = true

	var tween = self.create_tween()
	tween.tween_property(self, "global_position", destination, HOP_TIME_SEC).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
	await tween.finished
	game_manager.lilypad_done()

func die():
	print("You died!")
	queue_free()	
