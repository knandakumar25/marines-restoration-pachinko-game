extends Area2D

# Signal to be emitted when a ball collides with the orb.
signal ball_hit(damage)

@export var damage: int = 10  # Damage inflicted on the player.
@export var recoil_offset: Vector2 = Vector2(-20, 0)  # How far to move the sprite.
@export var recoil_duration: float = 0.5             # Duration of the recoil effect in seconds.

# Reference to the Sprite2D node for visual feedback.
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Add this orb to the "orbs" group so that level scripts can find it.
	add_to_group("orbs")
	# Connect the body_entered signal to our handler using a Callable.
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Ball collided with orb!")
		recoil_effect()
		# Emit the damage signal so that the level can reduce player health.
		ball_hit.emit(damage)
		# Remove the ball from the scene.
		body.queue_free()

func recoil_effect() -> void:
	var original_color = sprite.modulate
	var original_position = sprite.position

	# Apply the recoil effect: turn the sprite red and offset its position.
	sprite.modulate = Color(1, 0, 0)
	sprite.position += recoil_offset

	# Wait for the recoil duration.
	await get_tree().create_timer(recoil_duration).timeout

	# Revert the sprite's color and position.
	sprite.modulate = original_color
	sprite.position = original_position
