extends Node2D

@export var ball_scene: PackedScene
@export var peg_scene: PackedScene
@export var wall_scene: PackedScene
@export var goal_scene: PackedScene
@export var boss_scene: PackedScene
@onready var spawner: Marker2D = $Spawner

var boss
var goal
var spawn_timer = 0.0 # Timer to control automatic ball spawning
var spawn_interval = 2.0 # Time in seconds between each ball spawn

# Max values for randomization
var max_x = 1154
var max_y = 1452

func _ready() -> void:
	# Instance the Goal and add it to the scene
	goal = goal_scene.instantiate()
	goal.position = Vector2(577, 100)
	add_child(goal)
	
	# Instance the Boss and add it to the scene
	boss = boss_scene.instantiate()
	add_child(boss)
	
	# Connect the goal's ball_scored  signal to the boss's take_damage function
	goal.ball_scored.connect(boss.take_damage)
	
	# Randomly place pegs
	for i in range(10):  # Adjust the number of pegs as needed
		var peg = peg_scene.instantiate()
		peg.position = Vector2(randi_range(100, max_x), randi_range(100, max_y))  # Random position
		add_child(peg)

	# Randomly place and tilt walls
	for i in range(4):  # Adjust the number of walls as needed
		var wall = wall_scene.instantiate()
		wall.position = Vector2(randi_range(50, max_x - 100), randi_range(100, max_y - 100))  # Random position
		wall.rotation_degrees = randi_range(-45, 45)  # Random tilt angle between -45 and 45 degrees
		add_child(wall)

func _process(delta: float) -> void:
	# Automatically spawn balls at regular intervals
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0 # Reset timer
		spawn_ball()

func spawn_ball():
	var ball = ball_scene.instantiate()
	ball.position = spawner.position
	add_child(ball)
