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

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	print("Saved Game")
	file.store_string(JSON.stringify(level_data))
	file.close()
	

func load_game():
	print("Game Loaded")
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data:
		level_data = data

func save_level(level_name: String, coins: int, time: float):
	if not level_data[level_name]["completed"] or time < level_data[level_name]["time"]:
		level_data[level_name]["completed"] = true
		level_data[level_name]["coins"] = coins
		level_data[level_name]["time"] = time
		save_game()

func has_save() -> bool:
	# returns true if any level has been completed
	for level in level_data:
		if level_data[level]["completed"]:
			return true
	return false

func reset_game():
	# wipes all progress for new game
	for level in level_data:
		level_data[level]["completed"] = false
		level_data[level]["coins"] = 0
		level_data[level]["time"] = 0.0
	save_game()

func get_last_level() -> String:
	# finds the furthest incomplete level to continue from
	for level in LEVEL_SCENES:
		if not level_data[level]["completed"]:
			return LEVEL_SCENES[level]
	# if all levels complete, go to level 1
	return LEVEL_SCENES["level1"]
