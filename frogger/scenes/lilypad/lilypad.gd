extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_manager = $"../../../GameManager"
@onready var water_scene: PackedScene = preload("res://frogger/scenes/water/water.tscn")

func _ready() -> void:
	body_entered.connect(on_body_entered)

func spawn_water():
	var water_instance: Area2D = water_scene.instantiate()
	water_instance.body_entered.connect(on_water_body_entered)
	add_child(water_instance)

func on_body_entered(_body: CharacterBody2D):
	collision_shape.set_deferred("disabled", true)
	await _body.entered_lilypad(global_position)
	animated_sprite.play("claimed")
	call_deferred("spawn_water")

func on_water_body_entered(_body: CharacterBody2D):
	game_manager.kill_player()