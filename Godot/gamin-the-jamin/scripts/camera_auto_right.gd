extends Camera2D

@export var scroll_speed: float = 110.0
var delay_timer: float = 0.0
var delay_duration: float = 1.5

func _process(delta):
	if delay_timer < delay_duration:
		delay_timer += delta
		return                
	
	position.x += scroll_speed * delta
