extends PanelContainer

@export var title: String
@export var game_scene: PackedScene

func _ready() -> void:
	%TitleLabel.text = title
	gui_input.connect(on_gui_input)

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		get_tree().change_scene_to_packed(game_scene)

