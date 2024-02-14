class_name Results
extends Control


signal update_results

var total_questions: int
var correct_questions: int
var time_elapsed: float

@onready var final_correct_label: Label = %FinalCorrectLabel
@onready var final_time_label: Label = %FinalTimeLabel


func _on_update_results() -> void:
	var ratio = str(correct_questions) + "/" + str(total_questions)
	var grade = roundi((float(correct_questions) / total_questions) * 100)
	final_correct_label.text = "CORRECT ANSWERS: " + ratio + " (" + str(grade) + "%)"

	var seconds = fmod(time_elapsed, 60)
	var minutes = fmod(time_elapsed, 3600) / 60
	var time_elapsed_string = "%02d:%02d" % [minutes, seconds]
	final_time_label.text = time_elapsed_string
