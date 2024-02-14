class_name Background
extends Polygon2D


var _sakura_flower_scene: PackedScene = preload("res://scenes/sakura_flower.tscn")
var _spawn_left: bool = true

@onready var flower_spawn_timer: Timer = %FlowerSpawnTimer
@onready var _screen_width: float = get_viewport_rect().size.x


func _ready() -> void:
	# Add some flowers at game start
	for i in range(3):
		var flower: Node2D = _sakura_flower_scene.instantiate()

		flower.position.x = ((_screen_width * 0.3) * i) + 200
		flower.position.y = randf_range(-250, (get_viewport_rect().size.y * 0.1) + (i * 150))

		self.add_child(flower)


func _on_spawn_timer_timeout() -> void:
	var flower: Node2D = _sakura_flower_scene.instantiate()

	# Alternate spawning between left and right sides of the screen
	if _spawn_left:
		flower.position.x = randf_range(50, _screen_width * 0.5)
	else:
		flower.position.x = randf_range(_screen_width * 0.5, _screen_width - 50)

	flower.position.y = -300

	self.add_child(flower)

	flower_spawn_timer.wait_time = randf_range(7, 12)

	_spawn_left = !_spawn_left
