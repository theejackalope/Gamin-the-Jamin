extends Camera2D

@export var scroll_speed: float = 100.0

func _process(delta):
	position.x += scroll_speed * delta
