extends Node2D

var patrol_scene = preload("res://patrol.tscn")  # Path to your patrol scene
var patrols = []  # Array to store patrol instances
var player
var marauder

func _ready():
	# Get references to player and marauder
	player = $char  # Adjust this if the player node's name is different
	marauder = $maurauder  # Adjust this to your marauder node

	# Create multiple patrol instances at random positions
	for i in range(5):  # Example: 5 patrols
		var new_patrol = patrol_scene.instantiate()
		var random_pos = Vector2()  # Declare the variable here
		var is_position_valid = false
		
		while not is_position_valid:
			random_pos = Vector2(randi_range(100, 850), randi_range(100, 650))  # Adjusted bounds
			is_position_valid = true
			
			# Check if the new position collides with existing patrols
			for patrol in patrols:
				if patrol.position.distance_to(random_pos) < 100:  # Adjust distance threshold as needed
					is_position_valid = false
					break
		
		new_patrol.position = random_pos
		add_child(new_patrol)
		patrols.append(new_patrol)


func _process(delta):
	# Update marauder to chase the player
	marauder.player_position = player.position  # Pass player's position to the marauder
	
	# Optional: Control patrols here if needed
	for patrol in patrols:
		pass  # If patrol logic is handled in their script, no need to do anything here
