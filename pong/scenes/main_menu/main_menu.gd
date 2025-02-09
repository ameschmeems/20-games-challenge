extends Node


var game_select_screen_scene = load("res://common/UI/game_select_screen/game_select_screen.tscn")
var singleplayer_scene_path = "res://pong/scenes/singleplayer_arena/singleplayer_arena.tscn"
var multiplayer_scene_path = "res://pong/scenes/multiplayer_arena/multiplayer_arena.tscn"

func _ready() -> void:
	%SingleplayerButton.pressed.connect(on_singleplayer_button_pressed)
	%MultiplayerButton.pressed.connect(on_multiplayer_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)

func on_singleplayer_button_pressed() -> void:
	get_tree().change_scene_to_file(singleplayer_scene_path)

func on_multiplayer_button_pressed() -> void:
	get_tree().change_scene_to_file(multiplayer_scene_path)

func on_quit_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_select_screen_scene)