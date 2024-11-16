extends CharacterBody2D

# Define the speed of the platform in pixels per second
@export var speed = 100

# Define the waypoints for the platform
@export var waypoints = [
	Vector2(208, 140),  # Start position
	Vector2(208, -76),  # First end position
	Vector2(176, -76)   # Second end position
]

var current_target_index = 0
var moving_forward = true
var waiting = false

@onready var wait_timer = $wait_timer

func _ready():
	position = waypoints[0]
	wait_timer.connect("timeout", Callable(self, "_on_wait_timer_timeout"))

func _physics_process(delta):
	if waiting:
		return
	if current_target_index < waypoints.size():
		move_toward_target(delta)

func move_toward_target(delta):
	var target_position = waypoints[current_target_index]
	var direction = (target_position - position).normalized()
	var move_vector = direction * speed * delta

	# Ensure movement is pixel-perfect
	move_vector.x = round(move_vector.x)
	move_vector.y = round(move_vector.y)

	position += move_vector
	
	if position.distance_to(target_position) <= speed * delta:
		position = target_position
		if current_target_index == waypoints.size() - 1:
			wait_timer.start()
			waiting = true
		else:
			if moving_forward:
				current_target_index += 1
				if current_target_index >= waypoints.size():
					current_target_index -= 2
					moving_forward = false
			else:
				current_target_index -= 1
				if current_target_index < 0:
					current_target_index = 1
					moving_forward = true

func _on_wait_timer_timeout():
	waiting = false
	if moving_forward:
		current_target_index -= 1
	else:
		current_target_index += 1
	moving_forward = !moving_forward
