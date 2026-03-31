extends Node2D


@export var next_level: String
@onready var player: CharacterBody2D = $Player
@onready var main_music: AudioStreamPlayer = $Music/MainMusic
@onready var seen_music: AudioStreamPlayer = $Music/SeenMusic

@export var level_id = 1

@export var S_time = 0
@export var A_time = 0
@export var B_time = 0
@export var C_time = 0
@export var D_time = 0

@export var max_intel = 0

@onready var music_fade: AnimationPlayer = $Music/MusicFade

@export var fuck = false

var prev_seen = DATA.seen

func _ready() -> void:
	
	
	DATA.cur_level = level_id
	
	DATA.max_intel = max_intel
	
	DATA.S_time = S_time
	DATA.A_time = A_time
	DATA.B_time = B_time
	DATA.C_time = C_time
	DATA.D_time = D_time

func _process(delta: float) -> void:
	
	DATA.stopwatch = player.stopwatch_val
	
	
	if DATA.seen != prev_seen:
		if DATA.seen:
			music_fade.play("Seen")
		else:
			music_fade.play("Lost")
		
	prev_seen = DATA.seen


func died():
	DATA.death_stat += 1
	
func seen():
	DATA.seen_stat += 1
	
func start_music():
	$Music/MainMusic.play()
	$Music/SeenMusic.play()
	
func end_music():
	$Music/MainMusic.stop()
	$Music/SeenMusic.stop()
	
func _on_tree_exiting() -> void:
	DATA.save_game()
