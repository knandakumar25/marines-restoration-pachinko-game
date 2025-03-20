#extends Area2D
#
## Used ChatGPT to generate code to initialize and manage goal handling.
#
#signal ball_scored(damage) # Signal to track scoring
#
#@export var damage: int = 10 # Damage dealt to the boss
#
#func _ready() -> void:
	#connect("body_entered", _on_body_entered)
	#
#func _on_body_entered(body: Node2D) -> void:
	#if body is RigidBody2D:
		#print("Ball scored!")
		#ball_scored.emit(damage) # Emit signal
		#body.queue_free() # Remove ball after scoring
		
extends Area2D

signal ball_scored(damage)

@export var damage: int = 10  # Damage dealt to the boss

# Recoil settings
@export var recoil_offset: Vector2 = Vector2(-20, 0)  # How far to move the sprite
@export var recoil_duration: float = 0.5             # How long the recoil effect lasts (in seconds)

# Reference to your sprite node (rename "Sprite2D" if your node is named differently)
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Ball scored!")
		recoil_effect()
		ball_scored.emit(damage)
		body.queue_free()  # Remove the ball after scoring

func recoil_effect() -> void:
	var original_color = sprite.modulate
	var original_position = sprite.position

	# Turn sprite red
	sprite.modulate = Color(1, 0, 0)
	# Move it slightly backward (or in any direction you like)
	sprite.position += recoil_offset

	# Wait for half a second (or whatever recoil_duration is)
	await get_tree().create_timer(recoil_duration).timeout

	# Revert color and position
	sprite.modulate = original_color
	sprite.position = original_position
