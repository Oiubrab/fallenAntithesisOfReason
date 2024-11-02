extends CharacterBody2D

var player_position = Vector2()
var speed = 100
var pushback_velocity = Vector2()  # Stores the velocity from the pushback
var pushback_deceleration = 2000  # Controls how quickly the pushback slows down

func _process(delta):
	# Get the direction towards the player
	var direction = (player_position - position).normalized()

	# Move towards the player
	velocity = direction * (speed / 2.0)

	# Add any remaining pushback velocity to movement
	velocity += pushback_velocity

	# Move and handle collisions
	var collision = move_and_collide(velocity * delta)  # Store the result of move_and_collide()

	# Apply deceleration to smooth out the pushback
	if pushback_velocity.length() > 0:
		pushback_velocity = pushback_velocity.move_toward(Vector2.ZERO, pushback_deceleration * delta)

	# Check if a collision happened
	if collision:
		#print("Collision detected:")
		#print("Position:", collision.get_position())  # The point of collision
		#print("Normal:", collision.get_normal())      # The normal of the collision
		#print("Collider:", collision.get_collider())  # The object we collided with

		var pushback_force = get_node("../char").pushback_force

		if collision.get_collider().is_in_group("player"):  # Ensure the collider is the player
			collision.get_collider().decrease_health()  # Call the player's function

			# Push back the patrol or maurauder smoothly
			var pushback_direction = (position - collision.get_position()).normalized()
			pushback_velocity = pushback_direction * pushback_force  # Apply the pushback force as velocity
	
	# Check if moving right or left and flip the sprite
	if velocity.x > 0:
		$Sprite2D.flip_h = true  # Flips sprite horizontally when moving right
	elif velocity.x < 0:
		$Sprite2D.flip_h = false  # Normal orientation when moving left
