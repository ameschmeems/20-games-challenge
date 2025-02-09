extends Node

signal score_updated(p1_score: int, p2_score: int)

@export var ball_scene: PackedScene
@export var ball_position: Vector2
@export var pause_menu_scene: PackedScene
@export var main_menu_scene: PackedScene

@onready var sfx_score = $SfxScore
@onready var sfx_bounce1 = $SfxBounce1
@onready var sfx_bounce2 = $SfxBounce2

var ball_instance: CharacterBody2D
var p1_score: int = 0
var p2_score: int = 0
var bounce_sfx_change = false

func _ready() -> void:
	spawn_ball()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.current_scene = get_tree().current_scene.scene_file_path
		pause_menu_instance.main_menu_scene = main_menu_scene

func spawn_ball() -> void:
	ball_instance = ball_scene.instantiate() as CharacterBody2D
	ball_instance.global_position = ball_position
	add_child(ball_instance)
	ball_instance.scored_goal.connect(on_ball_scored_goal)

func bounce_sfx_play() -> void:
	if !bounce_sfx_change:
		sfx_bounce1.play()
	else:
		sfx_bounce2.play()
	bounce_sfx_change = !bounce_sfx_change

func emit_score_updated():
	score_updated.emit(p1_score, p2_score)

func on_ball_scored_goal(pos: Vector2) -> void:
	if pos.x <= 0:
		p2_score += 1
	else:
		p1_score += 1
	sfx_score.play()
	emit_score_updated()
	spawn_ball()
