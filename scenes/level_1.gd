extends Node2D

@export var ball_scene: PackedScene
@export var goal_scene: PackedScene
@export var boss_scene: PackedScene
@onready var player_health_label: Label = $PlayerHealth  # Reference to the PlayerHealth label

var boss
var goal
var player_health: int = 100  # Player's health
var y_threshold = 900  # Y-position threshold for detecting missed balls
var game_active = true  # Flag to control game activity

# Flag to control ball spawning cooldown
var can_spawn: bool = true

func _ready() -> void:
	# Instance the Goal and add it to the scene
	goal = goal_scene.instantiate()
	goal.position = Vector2(575, 900)
	add_child(goal)
	
	# Instance the Boss and add it to the scene
	boss = boss_scene.instantiate()
	boss.position = Vector2(100, 900)
	add_child(boss)
	
	$PlayerHealth.position = Vector2(650, 900)
	
	# Connect the goal's ball_scored signal to the boss's take_damage function
	goal.ball_scored.connect(boss.take_damage)

	# Initialize health display
	update_health_display()

func _process(delta: float) -> void:
	if not game_active:
		return  # Stop processing if game is over

	# Check if any balls have passed the y-axis threshold
	for ball in get_tree().get_nodes_in_group("balls"):
		if ball.position.y > y_threshold:
			print("Ball passed the threshold!")
			_on_health_reduced(-10)
			ball.queue_free()  # Remove the ball

	if not is_instance_valid(boss):
		game_active = false  # Stop spawning new balls
		$TextureRect/Finished.text = "Boss defeated! The door is now open! On to next level!"
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/black_2.tscn")

# Function to spawn a ball at the top of the screen at the mouse's x-coordinate
func spawn_ball_at_mouse(mouse_x: float) -> void:
	if game_active:
		var ball = ball_scene.instantiate()
		# Set position with x from the mouse and y at the top (0)
		ball.position = Vector2(mouse_x, 0)
		add_child(ball)
		ball.add_to_group("balls")

# Async function to spawn a ball and wait for a 2 second cooldown
func spawn_ball_with_cooldown(mouse_x: float) -> void:
	if can_spawn and game_active:
		spawn_ball_at_mouse(mouse_x)
		can_spawn = false
		await get_tree().create_timer(2.0).timeout
		can_spawn = true

# Listen for mouse clicks to spawn a ball at the mouse's x-coordinate
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spawn_ball_with_cooldown(event.position.x)

# Function to reduce player health
func _on_health_reduced(damage: int) -> void:
	print("Health reduced by: " + str(damage))
	player_health += damage  # Decrease health
	update_health_display()
	if player_health <= 0:
		print("Game Over!")
		game_active = false  # Stop spawning new balls
		await get_tree().create_timer(1.5).timeout  # Small delay before restarting
		get_tree().reload_current_scene()

# Function to update the health label display
func update_health_display() -> void:
	print("Updated Health: " + str(player_health))
	player_health_label.text = "Player Health: " + str(player_health)
