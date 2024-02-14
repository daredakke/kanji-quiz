class_name Main
extends Node2D


enum GAME_STATE { MAIN_MENU, QUIZ, RESULTS }

var currentState: GAME_STATE
var SFXBus = AudioServer.get_bus_index("SFX")

@onready var main_menu: Control = $MainMenu
@onready var quiz: Control = $Quiz
@onready var results: Control = $Results
@onready var button_click_sfx: AudioStreamPlayer2D = %ButtonClickSFX


func _ready() -> void:
	change_state(GAME_STATE.MAIN_MENU)


func change_state(new_state: GAME_STATE) -> void:
	currentState = new_state

	main_menu.visible = false
	quiz.visible = false
	results.visible = false

	match currentState:
		GAME_STATE.MAIN_MENU:
			main_menu.visible = true
		GAME_STATE.QUIZ:
			quiz.visible = true
		GAME_STATE.RESULTS:
			results.visible = true


# From reset dialogue during quiz
func _on_no_button_pressed() -> void:
	button_click_sfx.play()


func _on_yes_button_pressed() -> void:
	button_click_sfx.play()

	change_state(GAME_STATE.MAIN_MENU)


# From results screen
func _on_main_menu_button_pressed() -> void:
	button_click_sfx.play()

	change_state(GAME_STATE.MAIN_MENU)


func _on_main_menu_start_quiz(from, to, questions) -> void:
	button_click_sfx.play()

	quiz.from = from - 1
	quiz.to = to
	quiz.questions = questions

	quiz.emit_signal("generate_quiz")
	change_state(GAME_STATE.QUIZ)


func _on_quiz_view_results(total_questions, correct_questions, time_elapsed) -> void:
	results.total_questions = total_questions
	results.correct_questions = correct_questions
	results.time_elapsed = time_elapsed

	results.emit_signal("update_results")
	change_state(GAME_STATE.RESULTS)


func _on_sfx_toggle_button_toggled_on() -> void:
	AudioServer.set_bus_mute(SFXBus, false)
	button_click_sfx.play()


func _on_sfx_toggle_button_toggled_off() -> void:
	AudioServer.set_bus_mute(SFXBus, true)


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
