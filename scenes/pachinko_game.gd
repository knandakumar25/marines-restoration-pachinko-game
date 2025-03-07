extends Node2D

@export var ball_scene: PackedScene
@onready var spawner: Marker2D = $Spawner

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var ball = ball_scene.instantiate()
		ball.position = spawner.position
		add_child(ball)
