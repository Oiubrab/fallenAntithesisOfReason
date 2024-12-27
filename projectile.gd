extends CharacterBody2D

@export var speed: float = 400.0  # The speed of the projectile
@export var direction: Vector2 = Vector2.RIGHT  # Default direction (e.g., right)

func _ready():
	if direction.x < 0:
		$projectileSprite.flip_h = true

func _process(delta: float) -> void:
	# Update the projectile's position based on its speed and direction
	position += direction.normalized() * speed * delta
