extends Node

@export var ball_scene: PackedScene
@export var pause_menu_scene: PackedScene
@export var game_over_scene: PackedScene

@onready var brick_manager: Node = $BrickManager
@onready var paddle: CharacterBody2D = $Paddle

var ball_instance: CharacterBody2D
var main_menu_scene = load("res://common/UI/game_select_screen/game_select_screen.tscn")
var score = 0
var lives = 3
var save_data = {
	"high_score": 0
}

func _ready() -> void:
	load_data()
	spawn_ball()
	brick_manager.points_scored.connect(on_brick_manager_points_scored)
	brick_manager.screen_cleared.connect(on_screen_cleared)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.current_scene = get_tree().current_scene.scene_file_path
		pause_menu_instance.main_menu_scene = main_menu_scene


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

func load_data():
	if !FileAccess.file_exists("user://save_data"):
		return
	var file = FileAccess.open("user://save_data", FileAccess.READ)
	save_data = file.get_var()
	$HUD.update_high_score_display(save_data["high_score"])

func save():
	if score > save_data["high_score"]:
		save_data["high_score"] = score
		$HUD.update_high_score_display(save_data["high_score"])
	var file = FileAccess.open("user://save_data", FileAccess.WRITE)
	file.store_var(save_data)

func game_over():
	save()
	var game_over_instance = game_over_scene.instantiate()
	add_child(game_over_instance)
	game_over_instance.current_scene = get_tree().current_scene.scene_file_path
	game_over_instance.main_menu_scene = main_menu_scene

func on_ball_ball_dropped():
	lives -= 1
	if lives < 0:
		game_over()
	$HUD.update_lives_display(lives)
	spawn_ball()

func on_brick_manager_points_scored(points: int):
	score += points
	$HUD.update_score_display(score)

func on_screen_cleared():
	ball_instance.global_position = paddle.global_position + Vector2.UP * ball_instance.ball_radius * 2
	ball_instance.speed = 0
