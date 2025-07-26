extends CharacterBody2D

const TILE_SIZE: int = 64
const HOP_TIME_SEC: float = 0.15

var is_moving: bool = false

@onready var game_manager = $"../GameManager"

func _process(_delta: float) -> void:
	if position.x < 0 || position.x > 1280:
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
	var destination: Vector2 = position + direction * TILE_SIZE

	if destination.y > 768:
		return

	is_moving = true

	var tween = self.create_tween()

	tween.tween_property(self, "position", destination, HOP_TIME_SEC).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(flip_is_moving)
	tween.play()

func flip_is_moving():
	is_moving = !is_moving

func die():
	print("You died!")
	queue_free()	
