extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -280.0
const MUSHROOM_JUMP_VELOCITY = -500.0
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variable to track the last direction faced
var facing_left = false

func _ready():
	# Connect to the mushroom's signal
	for mushroom in get_tree().get_nodes_in_group("mushrooms"):
		mushroom.connect("mushroom_jumped", Callable(self, "_on_mushroom_jumped"))

func _physics_process(delta):
	# Animations
	if abs(velocity.x) > 1:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()  # Play the jump sound

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Update the facing direction
		if direction < 0:
			facing_left = true
		elif direction > 0:
			facing_left = false
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	# Move the player
	move_and_slide()

	animated_sprite_2d.flip_h = facing_left

func _on_mushroom_jumped(body):
	if body == self:
		velocity.y = MUSHROOM_JUMP_VELOCITY
		jump_sound.play()  # Play the jump sound when jumping on the mushroom
