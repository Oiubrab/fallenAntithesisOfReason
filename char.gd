extends CharacterBody2D

var speed = 200
var health = 5  # Starting health
var damage_cooldown = 0.5  # Cooldown time in seconds
var cooldown_timer = 0.0  # Timer for cooldown
var pushback_force = 800  # Define the pushback force here
var max_height = 0 # Stop the character from moving above the ground
var max_health = 5  # Maximum health
var projectile_scene = preload("res://projectile.tscn")
var projectile_cooldown: float = 0.5  # Cooldown time in seconds

@onready var camera: Camera2D = $Camera2D  # Reference to the Camera2D node
var target_offset: Vector2 = Vector2(20,0)  # Target offset for the camera
var offset_speed: float = 5.0  # Speed of interpolation

var projectile_spawn_conditions = {
	"standing": {"position":Vector2(50,-30),"direction":Vector2.RIGHT},
	"lookingUp": {"position":Vector2(65,-90),"direction":Vector2.from_angle(7.0*PI/4.0)},
	"crouching": {"position":Vector2(50,10),"direction":Vector2.RIGHT}
}

# Initial stance
var current_state = {"stance":"standing","is_facing_right": true, "is_firing": false}
var temp_new_state = {"stance":"standing","is_facing_right": true, "is_firing": false}

# Internal timer to manage cooldown
var time_since_last_shot: float = 0.0

func _ready():
	update_health_display()
	max_height = get_node("/root/main").char_max_height

func _process(delta):
	
	# Update the cooldown timer
	if time_since_last_shot > 0:
		time_since_last_shot -= delta
	
	# Smoothly interpolate the camera offset towards the target offset
	if has_node("Camera2D"):
		camera.offset = camera.offset.lerp(target_offset, offset_speed * delta)

	var input_vector = Vector2()

	# directional key presses 
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
		if not temp_new_state["is_facing_right"]:
			temp_new_state["is_facing_right"] = true
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
		if temp_new_state["is_facing_right"]:
			temp_new_state["is_facing_right"] = false
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up") and (position.y > max_height):
		input_vector.y -= 1

	# walking movement velocity
	input_vector = input_vector.normalized() * speed
	velocity = input_vector

	# Firing state key press
	if Input.is_action_pressed("ui_accept"):
		temp_new_state["is_firing"] = true
	else:
		temp_new_state["is_firing"] = false
		

	# Stance key presses
	if Input.is_key_pressed(KEY_KP_0):
		temp_new_state["stance"] = "lookingUp"
	elif Input.is_key_pressed(KEY_CTRL):
		temp_new_state["stance"] = "crouching"
	else:
		temp_new_state["stance"] = "standing"

	update_state(temp_new_state)

	# Call move_and_slide() after setting velocity
	var collision = move_and_collide(velocity * delta)

	# Check if a collision happened
	if collision:
		if collision.get_collider().is_in_group("threnss"):  # Ensure the collider is the player

			# Push back the patrol or maurauder smoothly
			var pushback_direction = (position - collision.get_position()).normalized()
			position += pushback_direction * 10  # Move this object back by 10 pixels
			
	# Handle cooldown
	if cooldown_timer > 0:
		cooldown_timer -= delta



func make_sprite_visible_from_state(parent: Node, stance: String) -> void:
	# Hide all sprites and disable all collision polygons first
	for child in parent.get_children():
		if child.has_method("set_visible"):
			child.visible = false
		
		# Disable collision polygons
		if child is CollisionPolygon2D:
			child.disabled = true
	
	# Make the selected sprite visible
	var sprite = parent.get_node(stance)
	sprite.visible = true
	
	# Enable the associated collision polygon
	var colliding_shape = parent.get_node(stance + "Collision")
	if colliding_shape is CollisionPolygon2D:
		colliding_shape.disabled = false


func shoot_projectile(new_state: Dictionary) -> void:
	# Instantiate the object
	var projectile_instance = projectile_scene.instantiate()
	
	projectile_instance.position = position + projectile_spawn_conditions[new_state["stance"]]["position"]
	projectile_instance.direction = projectile_spawn_conditions[new_state["stance"]]["direction"]

	# Add the projectile to the current scene
	get_tree().current_scene.add_child(projectile_instance)


func update_state(new_state: Dictionary) -> void:
	
	# Direction
	if new_state["is_facing_right"] != current_state["is_facing_right"]:
		$".".scale.x = -1 * $".".scale.x
		target_offset.x *= -1
		for stanceKey in projectile_spawn_conditions.keys():
			for vectorKey in projectile_spawn_conditions[stanceKey].keys():
				projectile_spawn_conditions[stanceKey][vectorKey] = projectile_spawn_conditions[stanceKey][vectorKey].reflect(Vector2.UP)

	# Stance
	if new_state["stance"] != current_state["stance"] or ((not new_state["is_firing"]) and current_state["is_firing"]):
		make_sprite_visible_from_state($".",new_state["stance"])
		if new_state["stance"] == "lookingUp":
			target_offset.y = -100  # Shift 100 pixels above the player
		else:
			target_offset.y = 0  # Reset to the default position

	# Firing
	if new_state["is_firing"]:
		make_sprite_visible_from_state($".",new_state["stance"] + "Firing")
		if time_since_last_shot <= 0:
			shoot_projectile(new_state)
			time_since_last_shot = projectile_cooldown
	if current_state != new_state:
		# Duplicate the new state and assign values
		current_state = new_state.duplicate()

# Function to update health when a collision occurs
func decrease_health():
	if cooldown_timer <= 0:  # Only decrease health if cooldown has passed
		health -= 1
		update_health_display()
		cooldown_timer = damage_cooldown  # Reset the cooldown timer
		if health <= 0:
			game_over()

func increase_health():
	if health<max_health:
		health += 1
		update_health_display()

# Function to update the health label in the UI
func update_health_display():
	if has_node("/root/main/CanvasLayer/AspectRatioContainer/Panel/char_health_label"):
		var label = get_node("/root/main/CanvasLayer/AspectRatioContainer/Panel/char_health_label")
		label.text = "Health: " + str(health)

# Game over function
func game_over():
	# Show the game over screen
	get_tree().change_scene_to_file("res://gameOver.tscn")
