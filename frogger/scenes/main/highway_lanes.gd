extends Node

@onready var game_manager = $"../GameManager"

func _ready() -> void:
	var highway_lanes = get_children()

	for lane in highway_lanes:
		lane.player_ran_over.connect(on_player_ran_over)

func on_player_ran_over():
	game_manager.kill_player()
