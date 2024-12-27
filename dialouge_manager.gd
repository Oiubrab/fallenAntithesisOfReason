extends Node

# Dialogue tree and other variables
var dialogue_tree = {}
var current_node_id = ""

# Paths to UI elements
@export var dialogue_label_path = "DialogueLabel"
@export var option_panel_path = "OptionPanel"
@export var button_scene = preload("res://Button.tscn")

@onready var dialogue_label = $DialogueLabel
@onready var option_panel = $OptionPanel

# Load the dialogue from the XML file
func load_dialogue_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var xml = XMLParser.new()
		xml.open_buffer(file.get_buffer(file.get_length()))
		var current_node_id = ""  # Track the current node ID being parsed
		var current_node_type = "" # Track the current tag type being parsed
		var current_option_text = ""  # Track the current option text (for options)
		var current_subnode_type = ""
		

		
		while xml.read() == OK:
			# Handle NODE_ELEMENT type
			if xml.get_node_type() == XMLParser.NODE_ELEMENT:
				if xml.get_node_name() == "node":
					current_node_id = xml.get_attribute_value(0) as String
					dialogue_tree[current_node_id] = {"text": "", "options": {}}
				elif xml.get_node_name() == "options" or xml.get_node_name() == "text":
					current_node_type = xml.get_node_name()
				elif xml.get_node_name() == "option":
					current_subnode_type = xml.get_node_name()
					
			# Handle NODE_TEXT type
			elif xml.get_node_type() == XMLParser.NODE_TEXT and not xml.get_node_data().strip_edges()=="":
				var node_data = xml.get_node_data().strip_edges()
				if current_node_type == "text":
					dialogue_tree[current_node_id][current_node_type] = node_data
				elif current_subnode_type == "option":
					#pass
					# Capture the actual option text
					dialogue_tree[current_node_id][current_node_type][xml.get_attribute_value(0)] = node_data
			# clear current type when node ends
			elif xml.get_node_type() == XMLParser.NODE_ELEMENT_END:
				if current_node_type=="options":
					current_subnode_type = ""
				elif current_node_type == "text":
					current_node_type = ""


# Start the dialogue
func start_dialogue(node_id: String = "1"):
	current_node_id = node_id
	if dialogue_tree.has(node_id):
		display_node(dialogue_tree[node_id])
		print("Dialogue tree structure:")
		print(dialogue_tree)
	else:
		print("Error: Node ID not found in dialogue tree.")
		# Print the entire dictionary for inspection
		print("Dialogue tree structure:")
		print(dialogue_tree)


# Display a dialogue node
func display_node(node: Dictionary):
	dialogue_label.clear()  # Clear the previous text
	dialogue_label.text = node["text"]  # Set the new dialogue text
	
	clear_children(option_panel)  # Clear previous buttons
	_create_option_buttons(node["options"])  # Create buttons for new options

# Create buttons for options
func _create_option_buttons(options: Dictionary):
	for option in options:
		var button = button_scene.instantiate()
		button.text = options[option]
		button.pressed.connect(Callable(self, "_on_option_selected").bind(option))
		option_panel.add_child(button)

# Handle option selection
func _on_option_selected(option: String):
	if dialogue_tree.has(option):
		current_node_id = option
		display_node(dialogue_tree[current_node_id])

# Utility to clear children of a parent node
func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()
