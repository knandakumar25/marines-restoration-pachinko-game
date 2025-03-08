extends Area2D

signal ball_scored(damage) # Signal to track scoring

@export var damage: int = 10 # Damage dealt to the boss

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Ball scored!")
		ball_scored.emit(damage) # Emit signal
		body.queue_free() # Remove ball after scoring
