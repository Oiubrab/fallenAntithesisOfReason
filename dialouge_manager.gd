extends Node

@export var dialogue_label_path = "RichTextLabel"  # Path to the RichTextLabel
@export var option_panel_path = "OptionPanel"  # Path to the panel for dialogue options
@export var button_scene = preload("res://Button.tscn")  # Preloaded Button scene

@onready var dialogue_label = $RichTextLabel
@onready var option_panel = $OptionPanel  # A VBoxContainer to hold option buttons

# Function to start dialogue with options
func start_dialogue_with_options(dialogue_lines: Array, options: Dictionary):
	dialogue_label.text = ""
	for child in option_panel.get_children():
		option_panel.remove_child(child)
		child.queue_free()  # Ensures the node is properly removed and freed from memory
	_display_dialogue(dialogue_lines)
	_create_option_buttons(options)

# Function to display dialogue lines
func _display_dialogue(dialogue_lines: Array):
	for line in dialogue_lines:
		dialogue_label.append_text(line + "\n")  # Appends each line of text


# Function to create option buttons
func _create_option_buttons(options: Dictionary):
	for option_text in options.keys():
		var button = button_scene.instantiate()
		button.text = option_text

		# Use Callable with arguments to pass the selected response
		button.connect("pressed", Callable(self, "_on_option_selected").bind(options[option_text]))

		option_panel.add_child(button)


# Function to handle selected options
func _on_option_selected(response: Array):
	# Update the dialogue with the selected response
	dialogue_label.text = ""  # Clear current dialogue
	_display_dialogue(response)
	for child in option_panel.get_children():
		option_panel.remove_child(child)
		child.queue_free()  # Ensures the node is properly removed and freed from memory
