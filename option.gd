extends Control

@onready var spec_wait: Timer = $SpecWait

@export var option_name: String
@export var option_size: int = 250

@export var is_level = true
@export var level_index = 0

@export var secret = false

var canclick = false

var clicked = false

var frame0 = true

@export var special = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = option_name
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if frame0:
		frame0 = false
		
		if is_level and !secret:
			if DATA.get_level(level_index - 1) == "?" and level_index != 1:
				process_mode = Node.PROCESS_MODE_DISABLED
				visible = false
				
		if is_level and secret and level_index == 13:
			if DATA.save_data["intel"] < DATA.every_intel_num:
				process_mode = Node.PROCESS_MODE_DISABLED
				visible = false
				
		if is_level and secret and level_index == 14:
			if !DATA.has_P_rank():
				process_mode = Node.PROCESS_MODE_DISABLED
				visible = false
		
	
	if canclick:
		$Label.add_theme_color_override("font_color",Color("C0C0C0"))
		
	else:
		$Label.add_theme_color_override("font_color",Color("FFFFFF"))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canclick and !clicked:
		get_child(2).clicked()
		clicked = true
		
		if special:
			spec_wait.start()

func _on_spec_wait_timeout() -> void:
	clicked = false


func _on_label_mouse_entered() -> void:
	canclick = true


func _on_label_mouse_exited() -> void:
	canclick = false
