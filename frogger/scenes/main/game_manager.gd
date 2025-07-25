extends Node

@onready var player = $"../Frog"

func kill_player():
	player.die()
