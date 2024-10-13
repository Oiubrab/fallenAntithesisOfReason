extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var sequence = 0
var epoch_random = 1
var rotation_random = 0
var base_speed = 10000  # Set a base speed for the patrol's normal movement
var pushback_velocity = Vector2()  # Stores the velocity from the pushback
var pushback_deceleration = 600  # Controls how quickly the pushback slows down

func _process(delta):
	sequence += 1
	auto_motion_rotational()
	auto_motion_linear(delta)

# Function for twisting motion
func auto_motion_rotational():
	if (sequence % int(epoch_random) == 0):
		rotation_random = rng.randf_range(-1.0, 1.0)
		epoch_random = rng.randf_range(1, 300)
	else:
		var gauss = (float(sequence % int(epoch_random)) - (float(epoch_random) / 2.0)) / float(epoch_random / 8)
		var gaussian = exp(-1.0 * pow(gauss, 2))
		rotation += (PI / 16) * rotation_random * gaussian

func auto_motion_linear(delta):
	# Generate random movement based on rotation
	var direction = Vector2(cos(rotation), sin(rotation)).normalized()

	# Speed increases as the patrol gets closer to the player (char)
	var char_position = get_node("../char").position
	var char_distance = position.distance_to(char_position)

	# Speed up as player gets closer
	var movement_speed = base_speed + 20000 * (1.0 / char_distance)  # Add base speed

	# Combine the base speed with the calculated speed
	var regular_velocity = direction * movement_speed * delta

	# Combine the regular movement and pushback velocity
	velocity = regular_velocity + pushback_velocity

	# Move and handle collisions
	var collision = move_and_collide(velocity * delta)

	# Apply deceleration to smooth out the pushback
	if pushback_velocity.length() > 0:
		pushback_velocity = pushback_velocity.move_toward(Vector2.ZERO, pushback_deceleration * delta)

	# Check if a collision happened
	if collision:
		print("Collision detected:")
		print("Position:", collision.get_position())  # The point of collision
		print("Normal:", collision.get_normal())      # The normal of the collision
		print("Collider:", collision.get_collider())  # The object we collided with

		var pushback_force = get_node("../char").pushback_force

		if collision.get_collider().is_in_group("player"):  # Ensure the collider is the player
			collision.get_collider().decrease_health()  # Call the player's function

			# Push back the patrol or maurauder smoothly
			var pushback_direction = (position - collision.get_position()).normalized()
			pushback_velocity = pushback_direction * pushback_force  # Apply the pushback force as velocity
