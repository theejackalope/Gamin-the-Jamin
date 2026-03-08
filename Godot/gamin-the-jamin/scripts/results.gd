extends Control

@onready var time_label = $TimeLabel
@onready var coins_label = $CoinsLabel
@onready var best_time_label = $BestTimeLabel

func _ready():
	var level = GameData.current_level
	var time = GameData.current_time
	var coins = GameData.current_coins
	var best = GameData.level_data[level]["time"]

	time_label.text = "Time: " + format_time(time)
	coins_label.text = "Coins Collected: " + str(coins)

	# show best time
	if best > 0.0:
		best_time_label.text = "Best Time: " + format_time(best)
	else:
		best_time_label.text = "Best Time: --:--"

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [mins, secs]

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/gas_station.tscn")
