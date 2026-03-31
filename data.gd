extends Node

const every_intel_num : int = 52

var seen = false
var squeue = []
var marked = []

var stopwatch = 0
var seen_stat = 0
var death_stat = 0

var max_intel = 0
var gained_intel = 0

var level_to_go = ""

var cur_level = 1

var S_time = 0
var A_time = 0
var B_time = 0
var C_time = 0
var D_time = 0

var save_data = {
	
	"sound" : 0.5,
	"music" : 0.5,
	# level ranks / showing which levels beaten
	"level0" : "?",
	"level1" : "?",
	"level2" : "?",
	"level3" : "?",
	"level4" : "?",
	"level5" : "?",
	"level6" : "?",
	"level7" : "?",
	"level8" : "?",
	"level9" : "?",
	"level10" : "?",
	"level11" : "?",
	"level12" : "?",
	"level13" : "?",
	# extra
	"seen" : 0,
	"deaths" : 0,
	"intel" : 0,
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if squeue.count(true) > 0:
		seen = true
	else:
		seen = false
		

func sq_append(val):
	squeue.append(val)
	
	return len(squeue) - 1
	
func mark_append(val):
	marked.append(val)
	
	return len(marked) - 1

func newlevel():
	squeue.clear()
	marked.clear()
	gained_intel = 0
	
func newlevel_full():
	stopwatch = 0
	seen_stat = 0
	death_stat = 0
	
func save_game():
	var save_file = FileAccess.open("user://data.save",FileAccess.WRITE)
	
	save_file.store_line(JSON.stringify(save_data))
	
func load_game():
	if not FileAccess.file_exists("user://data.save"):
		return
	
	var save_file = FileAccess.open("user://data.save", FileAccess.READ)
	
	var data = save_file.get_line()
	
	var json = JSON.new()
	
	var parse_result = json.parse(data)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())
		return
		
	save_data = json.get_data() #set save data to the loaded data
	
	
func get_level(id : int):
	
	if "level" + str(id) in save_data.keys():
		return save_data["level" + str(id)]
	else:
		return null
		
func get_level_str(id : int):
	
	if "level" + str(id) in save_data.keys():
		return "level" + str(id)
	else:
		return null
		
func has_P_rank():
	
	if DATA.save_data["level0"] != "P":
		return false
	
	if DATA.save_data["level1"] != "P":
		return false
	
	if DATA.save_data["level2"] != "P":
		return false
		
	if DATA.save_data["level3"] != "P":
		return false
		
	if DATA.save_data["level4"] != "P":
		return false
		
	if DATA.save_data["level5"] != "P":
		return false
		
	if DATA.save_data["level6"] != "P":
		return false
		
	if DATA.save_data["level7"] != "P":
		return false
		
	if DATA.save_data["level8"] != "P":
		return false
		
	if DATA.save_data["level9"] != "P":
		return false
		
	if DATA.save_data["level10"] != "P":
		return false
		
	if DATA.save_data["level11"] != "P":
		return false
		
	if DATA.save_data["level12"] != "P":
		return false
		
	if DATA.save_data["level13"] != "P":
		return false
	
	return true
