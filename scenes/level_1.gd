extends Node2D

@export var ball_scene: PackedScene
@export var goal_scene: PackedScene
@export var boss_scene: PackedScene
@onready var spawner: Marker2D = $Spawner
@onready var player_health_label: Label = $PlayerHealth  # Reference to the PlayerHealth label
@onready var popup_button: Button = $Button

var boss
var goal
# Removed automatic spawning variables: spawn_timer and spawn_interval
var player_health: int = 100  # Player's health
var y_threshold = 900  # Y-position threshold (unused now)
var game_active = true  # Flag to control game activity

# Max values for randomization (unused in current code but available)
var max_x = 1154
var max_y = 1452

# Flag to control ball spawning cooldown
var can_spawn: bool = true
var ball_count: int = 0
var button_timer: float = 4.0
var button_timer_running: bool = false

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
	popup_button.pressed.connect(_on_button_pressed)

	# Initialize health display
	update_health_display()
	
	popup_button.visible = false

func _process(delta: float) -> void:
	if not game_active:
		return  # Stop processing if game is over

	# Automatic ball spawning removed. Balls will only spawn on mouse click.
	
	if button_timer_running:
		button_timer -= delta
		popup_button.text = "Press Me! Time Left: %1.f" % button_timer
		if button_timer <= 0:
			button_timer_running = false

	if not is_instance_valid(boss):
		game_active = false  # Stop spawning new balls
		$TextureRect/Finished.text = "Boss defeated! The door is now open! On to next level!"
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/black_2.tscn")

# (Optional) Left here in case you need it later. It spawns a ball at the spawner's position.
func spawn_ball() -> void:
	if game_active:
		var ball = ball_scene.instantiate()
		ball.position = spawner.position
		add_child(ball)
		ball.add_to_group("balls")

# Function to spawn a ball at the top of the screen at the mouse's x-coordinate
func spawn_ball_at_mouse(mouse_x: float) -> void:
	if game_active:
		var ball = ball_scene.instantiate()
		# Set position with x from the mouse and y at the top (0)
		ball.position = Vector2(mouse_x, 0)
		add_child(ball)
		ball.add_to_group("balls")
		ball_count += 1
		if ball_count % 2 == 1:
			show_popup_button()

# Async function to spawn a ball and wait for a 4 second cooldown
func spawn_ball_with_cooldown(mouse_x: float) -> void:
	if can_spawn and game_active:
		spawn_ball_at_mouse(mouse_x)
		can_spawn = false
		await get_tree().create_timer(4.0).timeout
		can_spawn = true

# Listen for mouse clicks to spawn a ball at the mouse's x-coordinate
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spawn_ball_with_cooldown(event.position.x)

# Function to reduce player health (no longer called automatically)
func _on_health_reduced(damage: int) -> void:
	print("Health reduced by: " + str(damage))
	player_health += damage
	update_health_display()
	if player_health <= 0:
		print("Game Over!")
		game_active = false
		await get_tree().create_timer(1.5).timeout
		get_tree().reload_current_scene()

# Function to update the health label display
func update_health_display() -> void:
	print("Updated Health: " + str(player_health))
	player_health_label.text = "Player Health: " + str(player_health)

func show_popup_button() -> void:
	var screen_size = get_viewport_rect().size
	popup_button.position = Vector2(randf_range(100, screen_size.x - 200), randf_range(100, screen_size.y - 200))
	popup_button.visible = true
	button_timer_running = true
	button_timer = 4.0
	await get_tree().create_timer(4.0).timeout
	if popup_button.visible:
		print("Button not pressed. Moving vase to the left.")
		goal.position.x = 100
		popup_button.visible = false

func _on_button_pressed() -> void:
	print("Button pressed in time.")
	popup_button.visible = false
	goal.position.x = 575
