class_name MainMenu
extends Control

signal start_quiz(from: int, to: int, questions: int)

@onready var from_input: SpinBox = %FromSpinBox
@onready var to_input: SpinBox = %ToSpinBox
@onready var questions_input: SpinBox = %QuestionsSpinBox


func _on_start_button_pressed() -> void:
	start_quiz.emit(from_input.value, to_input.value, questions_input.value)


func _on_from_spin_box_value_changed(value: float) -> void:
	if int(value) > to_input.value:
		to_input.value = int(value)

	clamp_questions_input_value()


func _on_to_spin_box_value_changed(value: float) -> void:
	if int(value) < from_input.value:
		from_input.value = int(value)

	clamp_questions_input_value()


func _on_questions_spin_box_value_changed(_value: float) -> void:
	clamp_questions_input_value()


func clamp_questions_input_value() -> void:
	if questions_input.value > to_input.value - from_input.value:
		questions_input.value = to_input.value - from_input.value + 1
