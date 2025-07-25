extends Node

@export var vehicle_scene: PackedScene
@export var direction: Vector2 = Vector2.RIGHT
@export var num_vehicles: int = 3
@export var distance_between_vehicles: int = 100
@export var x_boundary: int = 550
@export var speed: int = 200

var vehicles = []

signal player_ran_over

func _ready() -> void:
	for i in num_vehicles:
		var vehicle = vehicle_scene.instantiate()
		vehicle.position = Vector2(-x_boundary, 0) + distance_between_vehicles * i * direction
		vehicle.body_entered.connect(on_vehicle_body_entered)
		add_child(vehicle)
		vehicles.append(vehicle)

func _process(delta: float) -> void:
	for vehicle in vehicles:
		var new_position = speed * delta * direction + vehicle.position
		if abs(new_position.x - x_boundary) < 10:
			vehicle.position.x = -x_boundary
		else:
			vehicle.position = new_position

func on_vehicle_body_entered(_body) -> void:
	print("Area entered!")
	player_ran_over.emit()
