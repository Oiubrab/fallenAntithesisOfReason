extends Area2D

@export var dialogue_lines = [
	"[color=yellow]Folgim:[/color] Welcome to my sanctum, Litta.",
	"[color=yellow]Folgim:[/color] You have choices to make, traveler."
]

@export var dialogue_options = {
	"What is this place?": ["[color=yellow]Folgim:[/color] This is my inner sanctum, the heart of my empire."],
	"Who are you?": ["[color=yellow]Folgim:[/color] I am Folgim, ruler of the infinite threads of reality."],
	"Leave me alone.": ["[color=yellow]Folgim:[/color] As you wish, but the void awaits."]
}

@onready var dialogue_manager = $"../../DialougeManager"
func _on_body_entered(body):
	if body.is_in_group("player"):
		dialogue_manager.start_dialogue_with_options(dialogue_lines, dialogue_options)
