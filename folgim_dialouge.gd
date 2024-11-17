extends Area2D

@onready var dialogue_manager = $"../../DialougeManager"
func _on_body_entered(body):
	if body.is_in_group("player"):
		dialogue_manager.load_dialogue_file("res://dialougeFolgim.xml")
		dialogue_manager.start_dialogue()
