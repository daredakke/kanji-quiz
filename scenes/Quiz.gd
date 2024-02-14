class_name Quiz
extends Control

signal generate_quiz
signal update_question
signal view_results(total_questions: int, correct_questions: int, time_elapsed: float)

@onready var dialogue_box: MarginContainer = $DialogueContainer
@onready var question_label: Label = %QuestionLabel
@onready var answer_1: Button = %AnswerButton1
@onready var answer_2: Button = %AnswerButton2
@onready var answer_3: Button = %AnswerButton3
@onready var answer_4: Button = %AnswerButton4
@onready var answer_buttons: Array[Button] = [answer_1, answer_2, answer_3, answer_4]
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

var file: String = "res://kanji.json"
var kanji_array = JSON.parse_string(FileAccess.get_file_as_string(file))
var quiz_array: Array
var keywords_array: Array[String]

var from: int
var to: int
var questions: int
var current_question: int
var correct_questions: int
var time_elapsed: float = 0
var question_just_answered: bool = false


func _ready() -> void:
	for kanji in kanji_array:
		keywords_array.push_back(kanji.keyword)


func _process(delta: float) -> void:
	time_elapsed += delta
	var seconds = fmod(time_elapsed, 60)
	var minutes = fmod(time_elapsed, 3600) / 60
	var time_elapsed_string = "%02d:%02d" % [minutes, seconds]
	time_label.text = time_elapsed_string

	if question_just_answered or !self.visible:
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
	quiz_array = kanji_array.slice(from, to + 1)
	quiz_array.shuffle()

	# Remove questions until quiz_array matches the question count given in size
	var to_remove = quiz_array.size() - questions

	for i in range(to_remove):
		quiz_array.pop_back()

	# Add incorrect answers
	for current_kanji in quiz_array:
		var incorrect_keywords: Array[String] = []

		# Need to get three incorrect keywords from keywords
		while incorrect_keywords.size() < 3:
			var incorrect: String = keywords_array.pick_random()

			if incorrect == current_kanji.keyword:
				continue

			incorrect_keywords.push_back(incorrect)

		current_kanji.incorrect_keywords = incorrect_keywords

	self.time_elapsed = 0
	self.current_question = 0
	self.correct_questions = 0
	self.update_question.emit()


func _on_update_question() -> void:
	# Question
	var current_kanji = quiz_array[current_question]
	question_label.text = current_kanji.kanji

	# Progress
	var ratio = str(current_question + 1) + "/" + str(quiz_array.size())
	current_question_label.text = "QUESTION: " + ratio

	# Answers
	var answers: Array[String] = current_kanji.incorrect_keywords
	answers.push_back(current_kanji.keyword)
	answers.shuffle()

	for i in range(4):
		answer_buttons[i].text = answers[i].to_upper()


func to_next_question() -> void:
	current_question += 1

	if current_question >= quiz_array.size():
		self.view_results.emit(quiz_array.size(), correct_questions, time_elapsed)
	else:
		self.update_question.emit()


func determine_result(answer: String) -> void:
	button_click_sfx.play()

	question_just_answered = true

	var correct_answer = quiz_array[current_question].keyword.to_upper()
	keyword_label.text = correct_answer

	if answer == correct_answer:
		question_pass_sfx.play()

		correct_questions += 1
		success_rect.visible = true
		fail_rect.visible = false
	else:
		question_fail_sfx.play()

		success_rect.visible = false
		fail_rect.visible = true

	feedback_container.visible = true

	next_question_delay.start()


func _on_answer_button_1_pressed() -> void:
	determine_result(answer_1.text)


func _on_answer_button_2_pressed() -> void:
	determine_result(answer_2.text)


func _on_answer_button_3_pressed() -> void:
	determine_result(answer_3.text)


func _on_answer_button_4_pressed() -> void:
	determine_result(answer_4.text)


func _on_next_question_delay_timeout() -> void:
	feedback_container.visible = false

	question_just_answered = false

	to_next_question()
