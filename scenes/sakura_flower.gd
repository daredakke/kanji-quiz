class_name SakuraFlower
extends Node2D


@onready var _direction: Vector2 = Vector2(randf_range(-0.2, 0.2), 3)
@onready var _speed: float = randf_range(5, 16)
@onready var _rotation_speed: float = randf_range(0.08, 0.25)


func _ready() -> void:
	if randf() > 0.5:
		_rotation_speed = -_rotation_speed

	scale = Vector2(1, 1) * randf_range(0.5, 0.85)


func _process(delta: float) -> void:
	position += _direction * _speed * delta
	rotation += _rotation_speed * delta

	if position.y > get_viewport_rect().size.y + 400:
		queue_free()
