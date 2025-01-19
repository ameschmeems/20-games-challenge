extends CharacterBody2D

@export var speed = 300

var ball: Node2D

func _physics_process(_delta: float) -> void:
	if (!ball):
		return
	
	var direction = (global_position - ball.global_position).normalized()
	velocity = direction * speed * Vector2.UP
	move_and_slide()
