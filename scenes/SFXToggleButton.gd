class_name SfxToggleButton
extends Button

signal toggled_on
signal toggled_off

@export var SFXOnTexture: CompressedTexture2D
@export var SFXOffTexture: CompressedTexture2D


func _ready() -> void:
	self.button_pressed = true


func _on_toggled(_button_pressed: bool) -> void:
	if self.button_pressed:
		self.toggled_on.emit()
		
		self.icon = SFXOnTexture
	else:
		self.toggled_off.emit()
		
		self.icon = SFXOffTexture
