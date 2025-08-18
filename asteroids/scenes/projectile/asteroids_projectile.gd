extends Area2D

@onready var screen_size = get_viewport_rect().size

var direction: Vector2 = Vector2.UP
var speed = 600

func _ready() -> void:
	$LifetimeTimer.timeout.connect(on_lifetime_timer_timeout)
	area_entered.connect(on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	screen_wrap()

func screen_wrap():
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)

func on_area_entered(area: Area2D):
	area.hit()
	queue_free()

func on_lifetime_timer_timeout():
	queue_free()
