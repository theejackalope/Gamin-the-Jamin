extends CanvasLayer

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func resume():
	get_tree().paused = false
	hide()

func _on_resume_button_pressed():
	resume()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
