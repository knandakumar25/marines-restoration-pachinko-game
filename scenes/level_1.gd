extends Node2D

@export var ball_scene: PackedScene
@export var goal_scene: PackedScene
@export var boss_scene: PackedScene
@onready var spawner: Marker2D = $Spawner
@onready var player_health_label: Label = $PlayerHealth  # Reference to the PlayerHealth label

var boss
var goal
var spawn_timer = 0.0  # Timer to control automatic ball spawning
var spawn_interval = 1.0  # Time in seconds between each ball spawn
var player_health: int = 100  # Player's health
var y_threshold = 900  # Y-position threshold for detecting missed balls
var game_active = true # Flag to control game activity

# Max values for randomization
var max_x = 1154
var max_y = 1452

func _ready() -> void:
	# Instance the Goal and add it to the scene
	goal = goal_scene.instantiate()
	goal.position = Vector2(575, 900)
	add_child(goal)
	
	# Instance the Boss and add it to the scene
	boss = boss_scene.instantiate()
	add_child(boss)
	
	# Connect the goal's ball_scored signal to the boss's take_damage function
	goal.ball_scored.connect(boss.take_damage)

	# Initialize health display
	update_health_display()

func _process(delta: float) -> void:
	if not game_active:
		return # Stop processing if game is over
	
	# Automatically spawn balls at regular intervals
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0  # Reset timer
		spawn_ball()
	
	# Check if any balls have passed the y-axis threshold
	for ball in get_tree().get_nodes_in_group("balls"):
		if ball.position.y > y_threshold:
			print("Ball passed the threshold!")
			_on_health_reduced(-10)
			ball.queue_free()  # Remove the ball

	if not is_instance_valid(boss):
		game_active = false # Stop spawning new balls
		$TextureRect/Finished.text = "Boss defeated! The door is now open! On to next level!"
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://scenes/black_2.tscn")

func spawn_ball():
	if game_active: # Only spawn if the game is still active
		var ball = ball_scene.instantiate()
		ball.position = spawner.position
		add_child(ball)
		ball.add_to_group("balls")  # Add ball to a group for easy tracking

# Function to reduce player health
func _on_health_reduced(damage: int) -> void:
	print("Health reduced by: " + str(damage))
	player_health += damage  # Decrease health
	update_health_display()
	if player_health <= 0:
		print("Game Over!")
		game_active = false # Stop spawning new balls
		await get_tree().create_timer(1.5).timeout # Small delay before restarting
		get_tree().reload_current_scene()
		# End the game or reset the scene

# Function to update the health label display
func update_health_display() -> void:
	print("Updated Health: " + str(player_health))
	player_health_label.text = "Player Health: " + str(player_health)
