extends Node2D

@onready var timer: Timer = $Timer
@onready var time_data: Label = $"Data/Time Data"
@onready var seen_data: Label = $"Data/Seen Data"
@onready var death_data: Label = $"Data/Death Data"
@onready var intel_data: Label = $"Data/Intel Data"
@onready var tick_sound: AudioStreamPlayer = $TickSound
@onready var final_rank: Label = $"Ranks/Final Rank"
@onready var seen_rank: Label = $"Ranks/Seen Rank"
@onready var intel_rank: Label = $"Ranks/Intel Rank"
@onready var death_rank: Label = $"Ranks/Death Rank"
@onready var time_rank: Label = $"Ranks/Time Rank"
@onready var presskey: Label = $NotChangingText/PRESSKEY

var next_action = 0

var finalscore = 0

var inp_val = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DATA.save_data["intel"] += DATA.gained_intel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	presskey.add_theme_color_override("font_color",Color(1,1 - ((inp_val * 4)/255.0),1 - ((inp_val * 4)/255.0)))
	
	if Input.is_anything_pressed() and next_action >= 9:
		inp_val += 2
	else:
		inp_val -= 4
		
	inp_val = clamp(inp_val,0,64)
		
	if inp_val == 64:
		DATA.newlevel_full()
		DATA.newlevel()
		SceneChanger.loadlevel(DATA.level_to_go)
		SceneChanger.switch_to_current()


func _on_start_timer_timeout() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	
	if next_action < 9:
		tick_sound.play()
	
	if next_action == 0:
		time_data.text = "%02d:%02d" % [(floor(DATA.stopwatch / 60)) , (DATA.stopwatch % 60)]
		time_data.add_theme_color_override("font_color",Color("#FFFFFF"))
		
	if next_action == 1:
		seen_data.text = str(DATA.seen_stat)
		seen_data.add_theme_color_override("font_color",Color("#FFFFFF"))
		
	if next_action == 2:
		death_data.text = str(DATA.death_stat)
		death_data.add_theme_color_override("font_color",Color("#FFFFFF"))
		
	if next_action == 3:
		intel_data.text = str(DATA.gained_intel) + " / " + str(DATA.max_intel)
		intel_data.add_theme_color_override("font_color",Color("#FFFFFF"))
		
	if next_action == 4:
		
		calc_final()
		
		if DATA.stopwatch <= DATA.S_time:
			time_rank.text = "S"
			time_rank.add_theme_color_override("font_color",Color("#0384fc"))
		elif DATA.stopwatch <= DATA.A_time:
			time_rank.text = "A"
			finalscore += 1
			time_rank.add_theme_color_override("font_color",Color("#03fca1"))
		elif DATA.stopwatch <= DATA.B_time:
			time_rank.text = "B"
			finalscore += 2
			time_rank.add_theme_color_override("font_color",Color("#03fc20"))
		elif DATA.stopwatch <= DATA.C_time:
			time_rank.text = "C"
			finalscore += 3
			time_rank.add_theme_color_override("font_color",Color("#fcb103"))
		elif DATA.stopwatch <= DATA.D_time:
			time_rank.text = "D"
			finalscore += 4
			time_rank.add_theme_color_override("font_color",Color("#fc5a03"))
		else:
			time_rank.text = "F"
			finalscore += 5
			time_rank.add_theme_color_override("font_color",Color("#fc0303"))
			
	if next_action == 5:
		
		calc_final()
		
		if DATA.seen_stat == 0:
			seen_rank.text = "S"
			seen_rank.add_theme_color_override("font_color",Color("#0384fc"))
		elif DATA.seen_stat == 1:
			seen_rank.text = "A"
			finalscore += 1
			seen_rank.add_theme_color_override("font_color",Color("#03fca1"))
		elif DATA.seen_stat <= 3:
			seen_rank.text = "B"
			finalscore += 2
			seen_rank.add_theme_color_override("font_color",Color("#03fc20"))
		elif DATA.seen_stat <= 4:
			seen_rank.text = "C"
			finalscore += 3
			seen_rank.add_theme_color_override("font_color",Color("#fcb103"))
		elif DATA.seen_stat <= 6:
			seen_rank.text = "D"
			finalscore += 4
			seen_rank.add_theme_color_override("font_color",Color("#fc5a03"))
		else:
			seen_rank.text = "F"
			finalscore += 5
			seen_rank.add_theme_color_override("font_color",Color("#fc0303"))
			
	if next_action == 6:
		
		calc_final()
		
		if DATA.death_stat == 0:
			death_rank.text = "S"
			death_rank.add_theme_color_override("font_color",Color("#0384fc"))
		elif DATA.death_stat <= 2:
			death_rank.text = "A"
			finalscore += 1
			death_rank.add_theme_color_override("font_color",Color("#03fca1"))
		elif DATA.death_stat <= 5:
			death_rank.text = "B"
			finalscore += 2
			death_rank.add_theme_color_override("font_color",Color("#03fc20"))
		elif DATA.death_stat <= 7:
			death_rank.text = "C"
			finalscore += 3
			death_rank.add_theme_color_override("font_color",Color("#fcb103"))
		elif DATA.death_stat <= 9:
			death_rank.text = "D"
			finalscore += 4
			death_rank.add_theme_color_override("font_color",Color("#fc5a03"))
		else:
			death_rank.text = "F"
			finalscore += 5
			death_rank.add_theme_color_override("font_color",Color("#fc0303"))
			
	if next_action == 7:
		
		calc_final()
		
		if DATA.max_intel == 0:
			
			if DATA.gained_intel == 0:
				intel_rank.text = "S"
				finalscore -= 5
				intel_rank.add_theme_color_override("font_color",Color("#0384fc"))
			else:
				intel_rank.text = "F"
				intel_rank.add_theme_color_override("font_color",Color("#fc0303"))
		else:
		
			var ratio = round((float(DATA.gained_intel) / float(DATA.max_intel) ) * 100)
			
			if ratio >= 100:
				intel_rank.text = "S"
				finalscore -= 5
				intel_rank.add_theme_color_override("font_color",Color("#0384fc"))
			elif ratio >= 80:
				intel_rank.text = "A"
				finalscore -= 4
				intel_rank.add_theme_color_override("font_color",Color("#03fca1"))
			elif ratio >= 60:
				intel_rank.text = "B"
				finalscore -= 3
				intel_rank.add_theme_color_override("font_color",Color("#03fc20"))
			elif ratio >= 40:
				intel_rank.text = "C"
				finalscore -= 2
				intel_rank.add_theme_color_override("font_color",Color("#fcb103"))
			elif ratio >= 20:
				intel_rank.text = "D"
				finalscore -= 1
				intel_rank.add_theme_color_override("font_color",Color("#fc5a03"))
			else:
				intel_rank.text = "F"
				intel_rank.add_theme_color_override("font_color",Color("#fc0303"))
				
				
	
	
	if next_action == 8:
		calc_final()
			
	if next_action == 9:
		return
	
	next_action += 1
	
	timer.start()


func calc_final():
	var fin_rank = ""
	
	if finalscore == -5:
		fin_rank = "P"
		final_rank.add_theme_color_override("font_color",Color("#ff00c8"))
	elif finalscore <= 0:
		fin_rank = "S"
		final_rank.add_theme_color_override("font_color",Color("#0384fc"))
	elif finalscore <= 3:
		fin_rank = "A"
		final_rank.add_theme_color_override("font_color",Color("#03fca1"))
	elif finalscore <= 6:
		fin_rank = "B"
		final_rank.add_theme_color_override("font_color",Color("#03fc20"))
	elif finalscore <= 8:
		fin_rank = "C"
		final_rank.add_theme_color_override("font_color",Color("#fcb103"))
	elif finalscore <= 11:
		fin_rank = "D"
		final_rank.add_theme_color_override("font_color",Color("#fc5a03"))
	else:
		fin_rank = "F"
		final_rank.add_theme_color_override("font_color",Color("#fc0303"))
		
		
	var rankscore = {"P":6,"S":5,"A":4,"B":3,"C":2,"D":1,"F":0,"?":0}
	
	if (rankscore[fin_rank] > rankscore[DATA.save_data[DATA.get_level_str(DATA.cur_level)]]):
		DATA.save_data[DATA.get_level_str(DATA.cur_level)] = fin_rank
	
	final_rank.text = fin_rank


func _on_tree_exiting() -> void:
	DATA.save_game()
