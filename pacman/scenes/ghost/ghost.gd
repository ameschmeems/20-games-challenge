extends Area2D

enum State {
	SCATTER,
	CHASE
}

enum GhostType {
	RED,

}

var current_scatter_index: int = 0
var current_state: State = State.SCATTER

@export var speed: float = 160
@export var movement_targets: Resource
@export var tile_map: TileMapLayer
@export var player: PacmanPlayer
@export var ghost_type: GhostType

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	nav_agent.navigation_finished.connect(on_navigation_finished)

	current_state = State.CHASE
	match ghost_type:
		GhostType.RED:
			$BodySprite.self_modulate = Color.RED

	setup()
	chase()
	# scatter()

func _process(delta: float) -> void:
	if (!NavigationServer2D.map_get_iteration_id(tile_map.get_navigation_map())):
		return
	move(nav_agent.get_next_path_position(), delta)

func setup() -> void:
	nav_agent.set_navigation_map(tile_map.get_navigation_map())
	NavigationServer2D.agent_set_map(nav_agent.get_rid(), tile_map.get_navigation_map())

func scatter() -> void:
	nav_agent.target_position = movement_targets.scatter_targets[current_scatter_index]

func chase() -> void:
	nav_agent.target_position = player.global_position

func move(target: Vector2, delta: float):
	var new_velocity = global_position.direction_to(target) * speed * delta
	global_position += new_velocity

func on_navigation_finished() -> void:
	current_scatter_index = (current_scatter_index + 1) % 4
	match current_state:
		State.SCATTER:
			scatter()
		State.CHASE:
			chase()
