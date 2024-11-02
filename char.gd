extends CharacterBody2D

var speed = 200
var health = 5  # Starting health
var damage_cooldown = 0.5  # Cooldown time in seconds
var cooldown_timer = 0.0  # Timer for cooldown
var pushback_force = 800  # Define the pushback force here
var max_height = 350 # Stop the character from moving above the ground
var max_health = 5  # Maximum health

func _ready():
	update_health_display()

func _process(delta):
	var input_vector = Vector2()

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up") and (position.y > max_height):
		input_vector.y -= 1

	input_vector = input_vector.normalized() * speed
	velocity = input_vector

	# Check if moving right or left and flip the sprite
	if velocity.x > 0:
		$Sprite2D.flip_h = false  # Normal orientation when moving right
	elif velocity.x < 0:
		$Sprite2D.flip_h = true  # Flips sprite horizontally when moving left




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
	if has_node("/root/main/CanvasLayer/Panel/char_health_label"):
		var label = get_node("/root/main/CanvasLayer/Panel/char_health_label")
		label.text = "Health: " + str(health)

# Game over function
func game_over():
	# Show the game over screen
	get_tree().change_scene_to_file("res://gameOver.tscn")
