extends Node2D

@onready var sound_slider: HSlider = $SettingsNode/SoundSlider
@onready var music_slider: HSlider = $SettingsNode/MusicSlider
@onready var scroll_container: ScrollContainer = $LevelScroll
@onready var seen: Label = $seen
@onready var deaths: Label = $deaths
@onready var intel: Label = $intel
@onready var pile: Node2D = $Pile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	DATA.newlevel()
	DATA.newlevel_full()
	
	DATA.load_game()
	
	sound_slider.value = DATA.save_data["sound"]
	music_slider.value = DATA.save_data["music"]
	
	
	if DATA.has_P_rank():
		pile.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug"):
		DATA.save_data["level1"] = "P"
		DATA.save_data["level2"] = "P"
		DATA.save_data["level3"] = "P"
		DATA.save_data["level4"] = "P"
		DATA.save_data["level5"] = "P"
		DATA.save_data["level6"] = "P"
		DATA.save_data["level7"] = "P"
		DATA.save_data["level8"] = "P"
		DATA.save_data["level9"] = "P"
		DATA.save_data["level10"] = "P"
		DATA.save_data["level11"] = "P"
		DATA.save_data["level12"] = "P"
		DATA.save_data["level13"] = "P"
		DATA.save_data["intel"] = 52
		
		DATA.save_game()
		SceneChanger.loadlevel(get_tree().current_scene.scene_file_path)
		SceneChanger.switch_to_current()
	
	seen.text = "SEEN: " + str(int(DATA.save_data["seen"]))
	deaths.text = "DEATHS: " + str(int(DATA.save_data["deaths"]))
	intel.text = "INTEL: " + str(int(DATA.save_data["intel"])) + " / " + str(DATA.every_intel_num)
	
	


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear_to_db(value))
	DATA.save_data["sound"] = value


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	DATA.save_data["music"] = value


func _on_tree_exiting() -> void:
	DATA.save_game()
