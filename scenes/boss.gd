extends Node2D

@export var max_health: int = 100
var current_health: int

func _ready() -> void:
	current_health = max_health
	update_health_display()

func update_health_display():
	$Label.text = "Boss Health: " + str(current_health)

func take_damage(damage):
	current_health -= damage
	update_health_display()
	if current_health <= 0:
		print("Boss defeated!")
		queue_free() # Remove boss from game
