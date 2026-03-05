extends Control

@onready var continue_button = $Continue

func _ready():
	GameData.load_game()
	
	# only show continue if at least one level has been completed
	if GameData.has_save():
		continue_button.show()
	else:
		continue_button.hide()

func _on_new_game_button_pressed():
	GameData.reset_game()  # wipes save data
	get_tree().change_scene_to_file("res://scenes/Yukon(level 1)/level1.tscn")

func _on_continue_button_pressed():
	get_tree().change_scene_to_file(GameData.get_last_level())

func _on_quit_button_pressed():
	get_tree().quit()
