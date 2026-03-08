extends CharacterBody2D

@export var move_speed: float = 200.0
var camera: Camera2D
var screen_half_width: float
var started: bool = false
var finished: bool = false

func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	screen_half_width = get_viewport_rect().size.x / 2
	# connect overlap detection
	$DamageArea.body_entered.connect(_on_damage_area_body_entered)

func _physics_process(delta):
	if finished:
		return

	if not started:
		var camera_right_edge = camera.global_position.x + screen_half_width
		if camera_right_edge >= global_position.x - 110:
			started = true

	if started:
		global_position.x -= move_speed * delta

		var camera_left_edge = camera.global_position.x - screen_half_width
		if global_position.x < camera_left_edge - 100:
			finished = true
			queue_free()

func _on_damage_area_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(2)
