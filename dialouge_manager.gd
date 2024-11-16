extends Control

var dialogue_lines = []  # Stores the dialogue lines
var current_index = 0  # Keeps track of the current dialogue line
var is_active = false  # To track if the dialogue is ongoing

# Reference to the RichTextLabel
@onready var text_label = $RichTextLabel  # Adjust path if needed

func start_dialogue(lines: Array):
	dialogue_lines = lines
	current_index = 0
	is_active = true
	text_label.visible = true
	update_text()

func update_text():
	if current_index < dialogue_lines.size():
		text_label.bbcode_text = dialogue_lines[current_index]
	else:
		end_dialogue()

func next_line():
	if is_active:
		current_index += 1
		update_text()

func end_dialogue():
	text_label.visible = false
	is_active = false

func _input(event):
	if is_active and event.is_action_pressed("ui_accept"):  # Replace "ui_accept" with your desired input
		next_line()
