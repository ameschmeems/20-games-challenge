extends Area2D
class_name PowerPellet

signal power_pellet_collected

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(_body: CharacterBody2D):
	power_pellet_collected.emit()
	queue_free()
