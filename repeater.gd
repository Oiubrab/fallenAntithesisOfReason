extends StaticBody2D

var health = 10000  # Set initial health for the repeater
#var can_take_damage = true 

func _ready():
	# Connect the signal using a Callable
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print("player: " + str(body.is_in_group("player")) + " threnss: " + str(body.is_in_group("threnss")))
	# Check if the colliding body is the character
	if body.is_in_group("player"):
		# Increase the character's health
		body.increase_health()

# Method to decrease health
func decrease_health(amount: int = 1):
	#if can_take_damage:
		health -= amount
		update_health_display()

		if health <= 0:
			destroy_repeater()

		## Start cooldown
		#can_take_damage = false
		#var timer = Timer.new()
		#timer.wait_time = 5
		#add_child(timer)
		#timer.start()
#
		#await timer.timeout 
		#can_take_damage = true
		#
# Optional: Method to display health
func update_health_display():
	# Add code to update health display (if you have a UI for it)
	var label = get_node("/root/main/CanvasLayer/Panel/" + str(self.name) + "_health_label")
	label.text = "Repeater " + str(self.name)[-1] + ": " + str(health)

# Method to handle what happens when health is zero
func destroy_repeater():
	queue_free()  # Removes this repeater instance from the scene
