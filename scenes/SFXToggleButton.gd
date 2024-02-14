class_name SfxToggleButton
extends Button


signal toggled_on
signal toggled_off

@export var SFXOnTexture: CompressedTexture2D
@export var SFXOffTexture: CompressedTexture2D


func _ready() -> void:
	button_pressed = true


func _on_toggled(_button_pressed: bool) -> void:
	if button_pressed:
		toggled_on.emit()
		
		icon = SFXOnTexture
	else:
		toggled_off.emit()
		
		icon = SFXOffTexture
