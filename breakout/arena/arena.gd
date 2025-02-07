extends Node

@export var ball_scene: PackedScene

@onready var brick_manager: Node = $BrickManager
@onready var paddle: CharacterBody2D = $Paddle

var ball_instance: CharacterBody2D

var score = 0

func _ready() -> void:
	spawn_ball()
	brick_manager.points_scored.connect(on_brick_manager_points_scored)
	brick_manager.screen_cleared.connect(on_screen_cleared)

func _physics_process(_delta: float) -> void:
	if ball_instance.speed == 0:
		ball_instance.global_position = paddle.global_position + Vector2.UP * ball_instance.ball_radius * 2
	if Input.is_action_just_pressed("launch_ball") && ball_instance.speed == 0:
		ball_instance.speed = ball_instance.starting_speed

func spawn_ball():
	ball_instance = ball_scene.instantiate()
	add_child(ball_instance)
	ball_instance.global_position = paddle.global_position + Vector2.UP * ball_instance.ball_radius * 2
	ball_instance.ball_dropped.connect(on_ball_ball_dropped)

func on_ball_ball_dropped():
	spawn_ball()

func on_brick_manager_points_scored(points: int):
	score += points
	print(score)

func on_screen_cleared():
	ball_instance.global_position = paddle.global_position + Vector2.UP * ball_instance.ball_radius * 2
	ball_instance.speed = 0
