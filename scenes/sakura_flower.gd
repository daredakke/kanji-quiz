class_name SakuraFlower
extends Node2D

@onready var direction: Vector2 = Vector2(randf_range(-0.2, 0.2), 3)
@onready var speed: float = randf_range(5, 16)
@onready var rotation_speed: float = randf_range(0.08, 0.25)


func _ready() -> void:
	if randf() > 0.5:
		rotation_speed = -rotation_speed

	self.scale = Vector2(1, 1) * randf_range(0.5, 0.85)


func _process(delta: float) -> void:
	self.position += direction * speed * delta
	self.rotation += rotation_speed * delta

	if self.position.y > get_viewport_rect().size.y + 400:
		self.queue_free()
