extends CharacterBody2D

@export var move_speed: float = 200.0
var camera: Camera2D
var screen_half_width: float
var started: bool = false
var finished: bool = false

func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	screen_half_width = get_viewport_rect().size.x / 2

func _physics_process(delta):
	if finished:
		return

	# start moving 20px before camera can see it
	if not started:
		var camera_right_edge = camera.global_position.x + screen_half_width
		if camera_right_edge >= global_position.x - 110:  # ← changed
			started = true

	# move by directly changing position - ignores all collisions
	if started:
		global_position.x -= move_speed * delta  # ← changed, plows through everything

		# stop once fully off the left edge of screen
		var camera_left_edge = camera.global_position.x - screen_half_width
		if global_position.x < camera_left_edge - 100:
			finished = true
			queue_free()
			
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()  # you can implement this on the player later
