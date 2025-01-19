extends CanvasLayer

@export var main_scene: Node

@onready var p1_score_label: Label = %P1Score
@onready var p2_score_label: Label = %P2Score

func _ready() -> void:
	p1_score_label.text = "0"
	p2_score_label.text = "0"
	main_scene.score_updated.connect(on_main_scene_score_updated)

func on_main_scene_score_updated(p1_score: int, p2_score: int):
	p1_score_label.text = str(p1_score)
	p2_score_label.text = str(p2_score)
