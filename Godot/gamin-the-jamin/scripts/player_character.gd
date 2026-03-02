extends CharacterBody2D
@onready var coin_label = $"../CanvasLayer/Label"

func _ready():
	coin_label.text = "Coins: 0"

const SPEED = 270.0
const JUMP_VELOCITY = -375.0

var coins: int = 0

func collect_loonie():
	coins += 1
	coin_label.text = "Coins: " + str(coins)
	print("Coins: ", coins)

func collect_toonie():
	coins += 2
	coin_label.text = "Coins: " + str(coins)
	print("Coins: ", coins)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
