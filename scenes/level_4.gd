extends Node2D

@export var ball_scene: PackedScene
@export var goal_scene: PackedScene
@export var boss_scene: PackedScene
@onready var spawner: Marker2D = $Spawner
@onready var player_health_label: Label = $PlayerHealth  # Reference to the PlayerHealth label
@onready var popup_button: Button = $Button

var boss
var goal
var player_health: int = 250  # Player's health
var y_threshold = 900  # Y-position threshold for detecting missed balls
var ball_count: int = 0
var button_timer: float = 1.0
var button_timer_running: bool = false
var can_spawn: bool = true
var game_active = true  # Flag to control game activity
var goal_direction: int = 1 # 1 moves right and -1 moves left
var goal_speed: float = 100.0

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
	boss.position = Vector2(100, 900)
	add_child(boss)
	
	$PlayerHealth.position = Vector2(650, 900)
	popup_button.pressed.connect(_on_button_pressed)
	
	# Connect the goal's ball_scored signal to the boss's take_damage function
	goal.ball_scored.connect(boss.take_damage)

	# Initialize health display
	update_health_display()
	popup_button.visible = false

func _process(delta: float) -> void:
	# Check for space bar or left mouse button press
	if Input.is_action_just_pressed("spawn_ball"):
		spawn_ball()
	
	# Check if any balls have pressed the y-axis threshold
	for ball in get_tree().get_nodes_in_group("balls"):
		if ball.position.y > y_threshold:
			print("Ball passed the threshold!")
			_on_health_reduced(-10)
			ball.queue_free() # Remove the ball
	
	# Check if the boss no longer exists to transition to the next level
	if not is_instance_valid(boss):
		$TextureRect/Finished.text = "Boss defeated! On to next level!"
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/black_5.tscn")
	if button_timer_running:
		button_timer -= delta
		popup_button.text = "Press Me! Time Left: %1.f" %button_timer
		if button_timer <= 0:
			button_timer_running = false
	goal.position.x += goal_speed * goal_direction * delta
	var screen_width = get_viewport_rect().size.x
	if goal.position.x <= 100 or goal.position.x >= screen_width - 100:
		goal_direction *= -1

func spawn_ball():
	if can_spawn and game_active:
		var ball = ball_scene.instantiate()
		ball.position = spawner.position
		add_child(ball)
		ball.add_to_group("balls")  # Add ball to a group for easy tracking
		ball_count += 1
	
		if ball_count % 2 == 0:
			show_popup_button()
		spawn_ball_with_cooldown()

# Async function to spawn a ball and wait for a 2 second cooldown
func spawn_ball_with_cooldown() -> void:
	if can_spawn and game_active:
		can_spawn = false
		await get_tree().create_timer(1.0).timeout
		can_spawn = true

# Function to reduce player health
func _on_health_reduced(damage: int) -> void:
	print("Health reduced by: " + str(damage))
	player_health += damage  # Decrease health
	update_health_display()
	if player_health <= 0:
		print("Game Over!")
		game_active = false
		await get_tree().create_timer(1.5).timeout # Small delay before restarting
		get_tree().reload_current_scene()
		# End the game or reset the scene

# Function to update the health label display
func update_health_display() -> void:
	print("Updated Health: " + str(player_health))
	player_health_label.text = "Player Health: " + str(player_health)

func show_popup_button() -> void:
	var screen_size = get_viewport_rect().size
	popup_button.position = Vector2(randf_range(100, screen_size.x - 200), randf_range(100, screen_size.y - 200))
	popup_button.visible = true
	button_timer_running = true
	button_timer = 1.0
	await get_tree().create_timer(1.5).timeout
	if popup_button.visible:
		print("Button not pressed. Moving vase to the left.")
		#goal.position.x = 100
		goal.visible = false
		popup_button.visible = false

func _on_button_pressed() -> void:
	print("Button pressed in time.")
	popup_button.visible = false
	#goal.position.x = 575
	goal.visible = true
