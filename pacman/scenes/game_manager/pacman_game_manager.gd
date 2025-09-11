extends Node

var score: int = 0
var lives: int = 3
var pellets_left: int = 0
var main_menu_scene: PackedScene = load("res://common/UI/game_select_screen/game_select_screen.tscn")
var ghost_array: Array[Ghost] = []

@onready var pause_menu_scene: PackedScene = preload("res://common/UI/pause_menu/pause_menu.tscn")
@onready var win_screen_scene: PackedScene = preload("res://common/UI/win_screen/win_screen.tscn")
@onready var game_over_scene: PackedScene = preload("res://common/UI/game_over_screen/game_over_screen.tscn")
@onready var power_pellet_timer: Timer = $PowerPelletTimer
@onready var sfx_pellet_eaten: AudioStreamPlayer = $SfxPelletEaten
@onready var sfx_power_pellet_eaten: AudioStreamPlayer = $SfxPowerPelletEaten

@export var hud: CanvasLayer
@export var player: PacmanPlayer
@export var pellets_node: Node2D
@export var ghosts_node: Node
@export var player_start_pos: Vector2 = Vector2(0.0, 229.0)

func _ready() -> void:
	hud.update_score_display(score)
	hud.update_lives_display(lives)
	player.player_died.connect(on_player_died)
	power_pellet_timer.timeout.connect(on_power_pellet_timer_timeout)
	for pellet in pellets_node.get_children():
		pellets_left += 1
		if pellet is Pellet:
			pellet.pellet_collected.connect(on_pellet_collected)
		if pellet is PowerPellet:
			pellet.power_pellet_collected.connect(on_power_pellet_collected)
	for ghost: Ghost in ghosts_node.get_children():
		ghost.ghost_eaten.connect(on_ghost_eaten)
		ghost_array.push_back(ghost)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)
		pause_menu_instance.current_scene = get_tree().current_scene.scene_file_path
		pause_menu_instance.main_menu_scene = main_menu_scene
		return
	
	if pellets_left == 0:
		var win_screen_instance = win_screen_scene.instantiate()
		add_child(win_screen_instance)
		win_screen_instance.current_scene = get_tree().current_scene.scene_file_path
		win_screen_instance.main_menu_scene = main_menu_scene
		return

func on_pellet_collected() -> void:
	score += 10
	pellets_left -= 1
	hud.update_score_display(score)
	sfx_pellet_eaten.play()

func on_power_pellet_collected() -> void:
	score += 50
	pellets_left -= 1
	hud.update_score_display(score)
	power_pellet_timer.start()
	for ghost in ghost_array:
		if ghost.current_state == Ghost.State.EATEN:
			return
		ghost.run_away()
		ghost.play_vuln_anim()
	sfx_power_pellet_eaten.play()

func on_player_died() -> void:
	get_tree().paused = true
	await player.anim.animation_finished
	player.process_mode = Node.PROCESS_MODE_INHERIT
	lives -= 1
	if lives == 0:
		var game_over_instance = game_over_scene.instantiate()
		game_over_instance.current_scene = get_tree().current_scene.scene_file_path
		game_over_instance.main_menu_scene = main_menu_scene
		add_child(game_over_instance)
		return
	hud.update_lives_display(lives)
	get_tree().paused = false
	player.anim.play("default")
	player.global_position = player_start_pos
	player.dying = false

func on_power_pellet_timer_timeout() -> void:
	for ghost in ghost_array:
		if ghost.current_state == Ghost.State.EATEN:
			return
		ghost.chase()
		ghost.play_default_anim()

func on_ghost_eaten() -> void:
	score += 200
	hud.update_score_display(score)
