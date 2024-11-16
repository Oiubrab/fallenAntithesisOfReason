extends Area2D

@export var dialogue_lines = [
	"[color=yellow]Folgim:[/color] Welcome to my inner sanctum, Litta.",
	"[color=mediumturquoise]Litta:[/color] What do you want from me?",
	"[color=yellow]Folgim:[/color] Everything, and yet nothing at all."
]  # Add the dialogue lines here

@onready var dialogue_manager = $"../../DialougeManager" # Adjust to your actual path

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure it's the player triggering the dialogue
		dialogue_manager.start_dialogue(dialogue_lines)
