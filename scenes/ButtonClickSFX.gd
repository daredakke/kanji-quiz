class_name ButtonClickSfx
extends AudioStreamPlayer2D


func _on_finished() -> void:
	self.pitch_scale = randf_range(0.95, 1.05)
