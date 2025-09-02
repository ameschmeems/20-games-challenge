extends Area2D

@export var teleport_location: Vector2

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: CharacterBody2D) -> void:
	body.set_deferred("global_position", teleport_location)