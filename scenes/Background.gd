class_name Background
extends Polygon2D

@onready var flower_spawn_timer: Timer = %FlowerSpawnTimer

var sakura_flower_scene: PackedScene = preload("res://scenes/sakura_flower.tscn")
var spawn_left: bool = true


func _ready() -> void:
	# Add some flowers at game start
	for i in range(3):
		var flower: Node2D = sakura_flower_scene.instantiate()

		flower.position.x = ((get_viewport_rect().size.x * 0.3) * i) + 200
		flower.position.y = randf_range(-250, (get_viewport_rect().size.y * 0.1) + (i * 150))

		self.add_child(flower)


func _on_spawn_timer_timeout() -> void:
	var flower: Node2D = sakura_flower_scene.instantiate()
	var spawn_x: float

	# Alternate spawning between left and right sides of the screen
	if spawn_left:
		spawn_x = randf_range(50, get_viewport_rect().size.x * 0.5)
	else:
		spawn_x = randf_range(get_viewport_rect().size.x * 0.5, get_viewport_rect().size.x - 50)

	flower.position.x = spawn_x
	flower.position.y = -300

	self.add_child(flower)

	flower_spawn_timer.wait_time = randf_range(7, 12)

	spawn_left = !spawn_left
