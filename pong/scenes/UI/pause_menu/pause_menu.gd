extends CanvasLayer

var current_scene: String
var main_menu_path = "res://pong/scenes/main_menu/main_menu.tscn"

func _ready() -> void:
	get_tree().paused = true
	%ResumeButton.pressed.connect(on_resume_button_pressed)
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%BackButton.pressed.connect(on_back_button_pressed)

func on_resume_button_pressed():
	get_tree().paused = false
	queue_free()

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(current_scene)

func on_back_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_path)