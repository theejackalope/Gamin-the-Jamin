extends Node

var level_data: Dictionary = {
	"level1": {"completed": false, "coins": 0, "time": 0.0},
	"level2": {"completed": false, "coins": 0, "time": 0.0},
	"level3": {"completed": false, "coins": 0, "time": 0.0},
	"level4": {"completed": false, "coins": 0, "time": 0.0},
}

# maps level names to their scene files
const LEVEL_SCENES = {
	"level1": "res://scenes/Yukon(level 1)/level1.tscn",
	"level2": "res://scenes/BC(level2)/level2.tscn",
	"level3": "res://scenes/Alberta(level3)/level3.tscn",
	"level4": "res://scenes/Sask(level4)/level4.tscn"
}

const SAVE_PATH = "user://savefile.json"

# stores current run stats to pass to results screen
var current_level: String = ""
var current_coins: int = 0
var current_time: float = 0.0
var total_coins: int = 0  # carries over between levels for spending at gas station

func save_game():
	print("Game Saved")
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify({
		"level_data": level_data,
		"total_coins": total_coins
	}))
	file.close()

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data:
		level_data = data["level_data"]
		total_coins = data.get("total_coins", 0)

func save_level(level_name: String, coins: int, time: float):
	current_level = level_name
	current_coins = coins
	current_time = time
	total_coins += coins  # add to spendable coins
	if not level_data[level_name]["completed"] or time < level_data[level_name]["time"]:
		level_data[level_name]["completed"] = true
		level_data[level_name]["coins"] = coins
		level_data[level_name]["time"] = time
	save_game()

func has_save() -> bool:
	for level in level_data:
		if level_data[level]["completed"]:
			return true
	return false

func reset_game():
	for level in level_data:
		level_data[level]["completed"] = false
		level_data[level]["coins"] = 0
		level_data[level]["time"] = 0.0
	total_coins = 0
	save_game()

func get_last_level() -> String:
	for level in LEVEL_SCENES:
		if not level_data[level]["completed"]:
			return LEVEL_SCENES[level]
	return LEVEL_SCENES["level1"]
