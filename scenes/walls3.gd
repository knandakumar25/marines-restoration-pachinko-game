extends StaticBody2D

@export var move_speed: float = 1.5 # Speed of movement
@export var move_range: float = 1000.0 # Max movement distance

var start_position: Vector2
var move_direction: Vector2 # Maximum movement distance

func _ready() -> void:
	start_position = position
	
	# Calculate movement direction based on rotation
	move_direction = Vector2.RIGHT
	
	move_wall()

func move_wall() -> void:
	var tween = create_tween()
	var target_position = start_position + move_direction * move_range
	
	# Move along the tilt direction
	tween.tween_property(self, "position", target_position, move_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", start_position, move_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(move_wall) # Loop movement
