extends Area2D

enum State {
	SCATTER,
	CHASE
}

enum GhostType {
	RED,
	PINK,
	BLUE,
	ORANGE
}

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

func _ready() -> void:
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	nav_agent.navigation_finished.connect(on_navigation_finished)

	body_entered.connect(on_body_entered)

	# current_state = State.SCATTER
	current_state = State.CHASE
	match ghost_type:
		GhostType.RED:
			body_anim.self_modulate = Color.RED
		GhostType.PINK:
			body_anim.self_modulate = Color.PINK
		GhostType.BLUE:
			body_anim.self_modulate = Color.TURQUOISE
		GhostType.ORANGE:
			body_anim.self_modulate = Color.ORANGE

	setup()
	chase()
	# scatter()

func _process(delta: float) -> void:
	if (!NavigationServer2D.map_get_iteration_id(tile_map.get_navigation_map())):
		return
	if current_state == State.CHASE:
		chase()
	move(nav_agent.get_next_path_position(), delta)

func setup() -> void:
	nav_agent.set_navigation_map(tile_map.get_navigation_map())
	NavigationServer2D.agent_set_map(nav_agent.get_rid(), tile_map.get_navigation_map())

func scatter() -> void:
	current_state = State.SCATTER
	nav_agent.target_position = movement_targets.scatter_targets[current_scatter_index]

func chase() -> void:
	current_state = State.CHASE
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
			scatter()
		State.CHASE:
			chase()

func on_body_entered(body: PacmanPlayer) -> void:
	body.die()
