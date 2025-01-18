extends CharacterBody2D

@export var speed = 300

func _physics_process(_delta: float) -> void:
	var direction = Input.get_axis("player_1_down", "player_1_up")
	velocity = direction * speed * Vector2.UP
	move_and_slide()
