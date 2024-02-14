class_name Quiz
extends Control


signal generate_quiz
signal update_question
signal view_results(total_questions: int, _correct_questions: int, _time_elapsed: float)

var from: int
var to: int
var questions: int

var _file: String = "res://kanji.json"
var _kanji_array = JSON.parse_string(FileAccess.get_file_as_string(_file))
var _quiz_array: Array
var _keywords_array: Array[String]
var _current_question: int
var _correct_questions: int
var _time_elapsed: float = 0
var _question_just_answered: bool = false

@onready var dialogue_box: MarginContainer = $DialogueContainer
@onready var question_label: Label = %QuestionLabel
@onready var answer_1: Button = %AnswerButton1
@onready var answer_2: Button = %AnswerButton2
@onready var answer_3: Button = %AnswerButton3
@onready var answer_4: Button = %AnswerButton4
@onready var current_question_label: Label = %CurrentQuestionLabel
@onready var time_label: Label = %TimeLabel
@onready var feedback_container: MarginContainer = %FeedbackContainer
@onready var keyword_label: Label = %KeywordLabel
@onready var success_rect: TextureRect = %SuccessRect
@onready var fail_rect: TextureRect = %FailRect
@onready var next_question_delay: Timer = %NextQuestionDelay
@onready var button_click_sfx: AudioStreamPlayer2D = %ButtonClickSFX
@onready var question_pass_sfx: AudioStreamPlayer2D = %QuestionPassSFX
@onready var question_fail_sfx: AudioStreamPlayer2D = %QuestionFailSFX
@onready var _answer_buttons: Array[Button] = [answer_1, answer_2, answer_3, answer_4]


func _ready() -> void:
	for kanji in _kanji_array:
		_keywords_array.push_back(kanji.keyword)


func _process(delta: float) -> void:
	_time_elapsed += delta
	
	var seconds = fmod(_time_elapsed, 60)
	var minutes = fmod(_time_elapsed, 3600) / 60
	var _time_elapsed_string = "%02d:%02d" % [minutes, seconds]
	time_label.text = _time_elapsed_string

	if _question_just_answered or !visible:
		return

	if Input.is_action_just_pressed("answer_1"):
		answer_1.pressed.emit()

	elif Input.is_action_just_pressed("answer_2"):
		answer_2.pressed.emit()

	elif Input.is_action_just_pressed("answer_3"):
		answer_3.pressed.emit()

	elif Input.is_action_just_pressed("answer_4"):
		answer_4.pressed.emit()


func _on_reset_button_pressed() -> void:
	button_click_sfx.play()

	dialogue_box.visible = true


func _on_yes_button_pressed() -> void:
	dialogue_box.visible = false


func _on_generate_quiz() -> void:
	# Generate and randomise set of questions
	_quiz_array = _kanji_array.slice(from, to + 1)
	_quiz_array.shuffle()

	# Remove questions until quiz_array matches the question count given in size
	var to_remove = _quiz_array.size() - questions

	for i in range(to_remove):
		_quiz_array.pop_back()

	# Add incorrect answers
	for current_kanji in _quiz_array:
		var incorrect_keywords: Array[String] = []

		# Need to get three incorrect keywords from keywords
		while incorrect_keywords.size() < 3:
			var incorrect: String = _keywords_array.pick_random()

			if incorrect == current_kanji.keyword:
				continue

			incorrect_keywords.push_back(incorrect)

		current_kanji.incorrect_keywords = incorrect_keywords

	_time_elapsed = 0
	_current_question = 0
	_correct_questions = 0
	update_question.emit()


func _on_update_question() -> void:
	# Question
	var current_kanji = _quiz_array[_current_question]
	question_label.text = current_kanji.kanji

	# Progress
	var ratio = str(_current_question + 1) + "/" + str(_quiz_array.size())
	current_question_label.text = "QUESTION: " + ratio

	# Answers
	var answers: Array[String] = current_kanji.incorrect_keywords
	answers.push_back(current_kanji.keyword)
	answers.shuffle()

	for i in range(4):
		_answer_buttons[i].text = answers[i].to_upper()


func _to_next_question() -> void:
	_current_question += 1

	if _current_question >= _quiz_array.size():
		view_results.emit(_quiz_array.size(), _correct_questions, _time_elapsed)
	else:
		update_question.emit()


func _determine_result(answer: String) -> void:
	button_click_sfx.play()

	_question_just_answered = true

	var correct_answer = _quiz_array[_current_question].keyword.to_upper()
	keyword_label.text = correct_answer

	if answer == correct_answer:
		question_pass_sfx.play()

		_correct_questions += 1
		success_rect.visible = true
		fail_rect.visible = false
	else:
		question_fail_sfx.play()

		success_rect.visible = false
		fail_rect.visible = true

	feedback_container.visible = true

	next_question_delay.start()


func _on_answer_button_1_pressed() -> void:
	_determine_result(answer_1.text)


func _on_answer_button_2_pressed() -> void:
	_determine_result(answer_2.text)


func _on_answer_button_3_pressed() -> void:
	_determine_result(answer_3.text)


func _on_answer_button_4_pressed() -> void:
	_determine_result(answer_4.text)


func _on_next_question_delay_timeout() -> void:
	feedback_container.visible = false
	_question_just_answered = false

	_to_next_question()
