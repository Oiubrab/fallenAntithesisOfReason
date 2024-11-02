extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Function to handle the "Start" button
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://battle_mood_question.tscn")  # Change to your main game scene

# Function to handle the "Quit" button
func _on_quit_button_pressed():
	get_tree().quit()  # Exit the game
