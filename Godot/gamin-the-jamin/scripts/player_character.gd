extends CharacterBody2D
@onready var coin_label = $"../UI/Coin Label"
@onready var timer_label = $"../UI/Timer Label"

const SPEED = 270.0
const JUMP_VELOCITY = -375.0

var pause_menu_scene = preload("res://scenes/Menus/pause_menu.tscn")
var pause_menu

var coins: int = 0
var elapsed_time: float = 0.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	coin_label.text = "Coins: 0"
	pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)

func _process(_delta):
	# only tick timer when game is not paused
	if not get_tree().paused:
		elapsed_time += _delta
		timer_label.text = format_time(elapsed_time)

	# handle pause toggle
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.resume()
		else:
			get_tree().paused = true
			pause_menu.show()
			
func collect_loonie():
	coins += 1
	coin_label.text = "Coins: " + str(coins)
	print("Coins: ", coins)

func collect_toonie():
	coins += 2
	coin_label.text = "Coins: " + str(coins)
	print("Coins: ", coins)

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]

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
