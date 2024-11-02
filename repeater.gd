extends Area2D

func _ready():
	# Connect the signal using a Callable
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print(body.is_in_group("player"))
	# Check if the colliding body is the character
	if body.is_in_group("player"):
		# Increase the character's health
		body.increase_health()
