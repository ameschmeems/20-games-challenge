extends Area2D
class_name Ghost

enum State {
	SCATTER,
	CHASE,
	RUN_AWAY,
	EATEN
}

enum GhostType {
	RED,
	PINK,
	BLUE,
	ORANGE
}

signal ghost_eaten

const TILE_SIZE: float = 27.0

var current_scatter_index: int = 0
var current_state: State = State.SCATTER

@export var speed: float = 160
@export var movement_targets: Resource
@export var tile_map: TileMapLayer
@export var player: PacmanPlayer
@export var ghost_type: GhostType

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var body_anim: AnimatedSprite2D = $BodyAnim
@onready var eye_anim: AnimatedSprite2D = $EyeAnim
@onready var chase_timer: Timer = $ChasePositionTimer
@onready var scatter_timer: Timer = $ScatterTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sfx_eaten: AudioStreamPlayer = $SfxEaten

func _ready() -> void:
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	nav_agent.navigation_finished.connect(on_navigation_finished)

	body_entered.connect(on_body_entered)

	scatter_timer.timeout.connect(on_scatter_timer_timeout)
	chase_timer.timeout.connect(on_chase_timer_timeout)

	play_default_anim()

	setup()
	scatter()

func _process(delta: float) -> void:
	if (!NavigationServer2D.map_get_iteration_id(tile_map.get_navigation_map())):
		return
	move(nav_agent.get_next_path_position(), delta)

func setup() -> void:
	nav_agent.set_navigation_map(tile_map.get_navigation_map())
	NavigationServer2D.agent_set_map(nav_agent.get_rid(), tile_map.get_navigation_map())

func scatter() -> void:
	current_state = State.SCATTER
	scatter_timer.start()
	nav_agent.target_position = get_scatter_pos()

func get_scatter_pos() -> Vector2:
	return movement_targets.scatter_targets[current_scatter_index]

func chase() -> void:
	current_state = State.CHASE
	chase_timer.start()

	match ghost_type:
		GhostType.RED:
			red_chase()
		GhostType.PINK:
			pink_chase()
		GhostType.BLUE:
			blue_chase()
		GhostType.ORANGE:
			orange_chase()

func red_chase() -> void:
	nav_agent.target_position = player.global_position

func pink_chase() -> void:
	nav_agent.target_position = player.global_position + 4 * TILE_SIZE * player.movement_direction

func blue_chase() -> void:
	nav_agent.target_position = (player.global_position - global_position) * 2

func orange_chase() -> void:
	if global_position.distance_to(player.global_position) < 8 * TILE_SIZE:
		scatter()
	else:
		nav_agent.target_position = player.global_position

func run_away() -> void:
	current_state = State.RUN_AWAY
	var random_rotation_degrees = randf_range(-PI/2, PI/2)
	nav_agent.target_position = (-global_position.direction_to(player.global_position)).rotated(random_rotation_degrees) * 8 * TILE_SIZE

func eaten() -> void:
	sfx_eaten.play()
	ghost_eaten.emit()
	current_state = State.EATEN
	nav_agent.target_position = Vector2.ZERO
	play_default_anim()
	body_anim.visible = false
	collision_shape.set_deferred("disabled", true)

func play_vuln_anim() -> void:
	eye_anim.visible = false
	body_anim.self_modulate = Color.WHITE
	body_anim.play("vulnerable")

func play_default_anim() -> void:
	eye_anim.visible = true
	match ghost_type:
		GhostType.RED:
			body_anim.self_modulate = Color.RED
		GhostType.PINK:
			body_anim.self_modulate = Color.PINK
		GhostType.BLUE:
			body_anim.self_modulate = Color.TURQUOISE
		GhostType.ORANGE:
			body_anim.self_modulate = Color.ORANGE
	body_anim.play("move") 

func move(target: Vector2, delta: float):
	var new_velocity = global_position.direction_to(target) * speed * delta
	if new_velocity.x > 0.5:
		eye_anim.play("move_right")
	elif new_velocity.x < -0.5:
		eye_anim.play("move_left")
	elif new_velocity.y > 0.5:
		eye_anim.play("move_down")
	elif new_velocity.y < -0.5:
		eye_anim.play("move_up")
	global_position += new_velocity

func on_navigation_finished() -> void:
	current_scatter_index = (current_scatter_index + 1) % movement_targets.scatter_targets.size()
	match current_state:
		State.SCATTER:
			nav_agent.target_position = get_scatter_pos()
		State.CHASE:
			chase()
		State.RUN_AWAY:
			run_away()
		State.EATEN:
			body_anim.visible = true
			body_anim.play("move")
			collision_shape.set_deferred("disabled", false)
			chase()

func on_body_entered(body: PacmanPlayer) -> void:
	if current_state != State.RUN_AWAY:
		body.die()
	else:
		eaten()

func on_scatter_timer_timeout() -> void:
	if current_state == State.SCATTER:
		chase()

func on_chase_timer_timeout() -> void:
	if current_state == State.CHASE:
		chase()
