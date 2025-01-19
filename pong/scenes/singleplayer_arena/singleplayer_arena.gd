extends Node

signal score_updated(p1_score: int, p2_score: int)

@export var ball_scene: PackedScene
@export var ball_position: Vector2

@onready var cpu_paddle = $CPUPaddle

var ball_instance: CharacterBody2D
var p1_score: int = 0
var p2_score: int = 0

func _ready() -> void:
	spawn_ball()

func spawn_ball() -> void:
	ball_instance = ball_scene.instantiate() as CharacterBody2D
	ball_instance.global_position = ball_position
	add_child(ball_instance)
	ball_instance.scored_goal.connect(on_ball_scored_goal)
	cpu_paddle.ball = ball_instance

func emit_score_updated():
	score_updated.emit(p1_score, p2_score)

func on_ball_scored_goal(pos: Vector2) -> void:
	if pos.x <= 0:
		p2_score += 1
	else:
		p1_score += 1
	emit_score_updated()
	spawn_ball()

