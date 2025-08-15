extends CanvasLayer

@export var main_menu_scene: PackedScene

var current_scene: String

func _ready() -> void:
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%BackButton.pressed.connect(on_back_button_pressed)

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(current_scene)

func on_back_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)