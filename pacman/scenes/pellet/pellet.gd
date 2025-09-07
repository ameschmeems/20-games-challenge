extends Area2D
class_name Pellet

signal pellet_collected

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(_body: CharacterBody2D):
	pellet_collected.emit()
	queue_free()