extends Node

@onready var game_manager = $"../GameManager"

func _ready() -> void:
	var lanes = get_children()

	for lane in lanes:
		lane.player_drowned.connect(on_player_drowned)

func on_player_drowned():
	game_manager.kill_player()
