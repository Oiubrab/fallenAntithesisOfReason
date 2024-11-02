extends Node2D

var patrol_scene = preload("res://patrol.tscn")  # Path to your patrol scene
var patrols = []  # Array to store patrol instances
var player
var marauder
var repeater_scene = preload("res://repeater.tscn")

enum battle_states {
	RAIDERHUNTER,
	INVASION,
	REINFORCEMENT,
	PEACE
}

var battle_state = battle_states.PEACE

func spawn_repeaters():
	for i in range(3):
		# Create an instance of the Repeater
		var repeater_instance = repeater_scene.instantiate()
		repeater_instance.name = "repeater" + str(i + 1)  # Assign a predictable name: repeater1, repeater2, repeater3
		# Randomly set its position within the specified bounds
		var x_position = randi_range(0, 3456)
		var y_position = randi_range(384, 560)
		repeater_instance.position = Vector2(x_position, y_position)

		# Add the repeater instance to the "Repeater" group
		repeater_instance.add_to_group("repeater")

		# Add the instance to the scene tree
		add_child(repeater_instance)

func spawn_patrol():
	# Create multiple patrol instances at random positions
	for i in range(10):  # 10 patrols
		var new_patrol = patrol_scene.instantiate()
		var random_pos = Vector2()  # Declare the variable here
		var is_position_valid = false
		
		new_patrol.add_to_group("threnss")
		
		while not is_position_valid:
			random_pos = Vector2(randi_range(100, 3328), randi_range(100, 350))  # Adjusted bounds
			is_position_valid = true
			
			# Check if the new position collides with existing patrols
			for patrol in patrols:
				if patrol.position.distance_to(random_pos) < 100:  # Adjust distance threshold as needed
					is_position_valid = false
					break
		
		new_patrol.position = random_pos
		add_child(new_patrol)
		patrols.append(new_patrol)

func _ready():
	spawn_repeaters()
	spawn_patrol()

	# Get references to player and marauder
	player = $char  # Adjust this if the player node's name is different
	marauder = $maurauder  # Adjust this to your marauder node

func _process(_delta):
	# Update marauder to chase the player
	marauder.player_position = player.position  # Pass player's position to the marauder
	
	var time_left = $survival_timer.time_left
	var status = get_node("CanvasLayer/Panel/status_label")
	if time_left > 120.0 and time_left < 180.0 and battle_state == battle_states.PEACE:
		battle_state = battle_states.RAIDERHUNTER
		status.text = "Status: Raiders And Hunters"
	elif time_left > 60.0 and time_left < 120.0 and battle_state == battle_states.RAIDERHUNTER:
		battle_state = battle_states.INVASION
		status.text = "Status: Invasion"
	elif time_left < 60.0 and battle_state == battle_states.INVASION:
		battle_state = battle_states.REINFORCEMENT
		status.text = "Status: Reinforcement"


func _on_survival_timer_timeout() -> void:
	print("Timer finished!")
