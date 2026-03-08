extends CharacterBody2D

@onready var coin_label = $"../UI/Coin Label"
@onready var timer_label = $"../UI/Timer Label"
@onready var hearts_container = $"../UI/HBoxContainer"  # ← add this

const SPEED = 270.0
const JUMP_VELOCITY = -400.0
const ABSOLUTE_MAX_HEALTH = 7

var heart_texture = preload("res://path/to/your/heart.png")  # ← update this path

var pause_menu_scene = preload("res://scenes/Menus/pause_menu.tscn")
var pause_menu
var coins: int = 0
var elapsed_time: float = 0.0
var health: int = 5
var max_health: int = 5
var is_dead: bool = false
var invincible: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	coin_label.text = "Coins: 0"
	pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)
	update_hearts()  # ← add this

func _process(_delta):
	if not get_tree().paused:
		elapsed_time += _delta
		timer_label.text = format_time(elapsed_time)
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.resume()
		else:
			get_tree().paused = true
			pause_menu.show()

func update_hearts():
	for child in hearts_container.get_children():
		child.queue_free()
	for i in range(health):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.custom_minimum_size = Vector2(32, 32)  # ← adjust to your heart image size
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearts_container.add_child(heart)

func take_damage():
	if invincible or is_dead:
		return
	health -= 1
	update_hearts()
	if health <= 0:
		die()
	else:
		invincible = true
		await get_tree().create_timer(1.0).timeout
		invincible = false

func add_heart():
	if max_health >= ABSOLUTE_MAX_HEALTH:
		return
	max_health += 1
	health += 1
	update_hearts()

func die():
	is_dead = true
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/Yukon(level 1)/level1.tscn")  # ← update path

func complete_level():
	GameData.save_level("level1", coins, elapsed_time)
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

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
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
