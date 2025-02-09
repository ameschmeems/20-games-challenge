extends CharacterBody2D

@export var speed = 300

func _physics_process(_delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	velocity = direction * speed * Vector2.RIGHT
	move_and_slide()
