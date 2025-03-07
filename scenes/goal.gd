extends Area2D

signal ball_scored # Signal to track scoring

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		print("Ball scored!")
		ball_scored.emit() # Emit signal
		body.queue_free() # Remove ball after scoring
