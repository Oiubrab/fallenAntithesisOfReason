extends Node

# Game-wide data
var items = []
var progress = {"level": 1, "score": 0}
var player_name = "Player"

# Save file path
const SAVE_PATH = "user://save_game.json"

# Save data to a file
func save_game() -> void:
	var save_data = {
		"items": items,
		"progress": progress,
		"player_name": player_name
	}
	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	print("Game saved!")

# Load data from a file
func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		
		# Parse the JSON string
		var save_data = JSON.parse_string(json_string)
		
		if save_data != null:
			# Assign each key in the save file to the corresponding global variable
			for key in save_data.keys():
				if key in self:  # Check if the property exists in the current object
					self[key] = save_data[key]  # Dynamically assign the value
			print("Game loaded successfully!")
		else:
			print("Error parsing JSON.")
	else:
		print("No save file found.")
