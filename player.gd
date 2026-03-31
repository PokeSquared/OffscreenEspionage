extends CharacterBody2D

@onready var player: Node2D = $".."
@onready var center_pivot: Node2D = $"../CenterPivot"
@onready var camera_2d: Camera2D = $Camera2D
@onready var mask: Node2D = $"../Mask"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var void_collision: Area2D = $VoidCollision
@onready var tile_map_layer: TileMapLayer = $"../NavigationRegion2D/TileMapLayer"
@onready var sprintlabel: Label = $CanvasLayer/Sprint
@onready var seen: AnimatedSprite2D = $CanvasLayer/Seen
@onready var mark_area: Area2D = $MarkArea
@onready var sprint_bar: ColorRect = $CanvasLayer/SprintBar
@onready var marked_label: Label = $CanvasLayer/MarkedLabel
@onready var stopwatch_label: Label = $CanvasLayer/StopWatchText
@onready var death_sound: AudioStreamPlayer = $DeathSound
@onready var death_timer: Timer = $DeathTimer
@onready var black: ColorRect = $CanvasLayer/Black
@onready var black_anim: AnimationPlayer = $CanvasLayer/Black/BlackAnim
@onready var mark_sound: AudioStreamPlayer = $MarkSound
@onready var world: Node2D = $".."
@onready var restart: Label = $CanvasLayer/Restart
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stuck_coll: Area2D = $StuckColl
@onready var stuck_timer: Timer = $StuckTimer

var speed = 125
var camfrozen = false
var colldist = 10
var sprint = 1.55
var dead = true

var sprintmax = 50
var sprint_left = sprintmax

var tomark = null

var stopwatch_val = 0

var frame0 = false

var restartval = 0

var stuck = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	black.visible = true
	black_anim.play("Fade")
	
	stopwatch_val = DATA.stopwatch 



func _physics_process(delta):
	
	if Input.is_action_just_pressed("debug"):
		for x in range(len(DATA.marked)):
			DATA.marked[x] = true
	
	
	if (len(stuck_coll.get_overlapping_bodies()) > 0) and get_collision_layer_value(3):
		
		stuck = true
		
		if (stuck_timer.is_stopped()):
			stuck_timer.start()
	else:
		stuck = false
	
	if !camfrozen:
		sprite.material.set_shader_parameter("apply",false)
	else:
		sprite.material.set_shader_parameter("apply",true)
	
	for x in $MarkArea.get_overlapping_bodies():
		if x.is_in_group("Markable") and len(DATA.marked) > 0:
			if (DATA.marked[x.marked_index] == false):
				tomark = x
	
	if !frame0:
		SceneChanger.loadlevel(get_tree().current_scene.scene_file_path)
		frame0 = true
	
	if DATA.seen:
		seen.frame = 1
	else:
		seen.frame = 0
	
	sprintlabel.text = str(sprint_left)
	
	if ((DATA.marked).count(true) == len(DATA.marked)) and !dead and !world.fuck:
		marked_label.add_theme_color_override("font_color",Color("FF0000"))
		dead = true
		black_anim.play_backwards("Fade")
		world.end_music()
	
	marked_label.text = str((DATA.marked).count(true))+ "/" + str(len(DATA.marked))
	
	if (floor(stopwatch_val / 60)) >= 100:
		stopwatch_label.text = "dude did you like die IRL?\nyou've been here\nfor 100+ minutes..."
		stopwatch_label.global_position.y =  467.0 - 35
	else:
		stopwatch_label.text = "%02d:%02d" % [(floor(stopwatch_val / 60)) , (stopwatch_val % 60)]
	
	
	var playerpos = global_position
	var tilemaplocal = tile_map_layer.to_local(playerpos)
	var playercell = tile_map_layer.local_to_map(tilemaplocal)
	
	if camfrozen:
		camera_2d.global_position = center_pivot.global_position
	else:
		camera_2d.global_position = global_position
	
	var voidpos = Vector2.ZERO
	
	if Input.is_action_pressed("Restart"):
		restart.text = "Restarting..."
	elif Input.is_action_pressed("Menu"):
		restart.text = "Ending Level..."
	
	
	if Input.is_action_pressed("Restart") or Input.is_action_pressed("Menu") and !dead:
		restartval += 1
		restartval = clamp(restartval,0,125)
		
		restart.visible_ratio += 0.01
		restart.visible_ratio = clamp(restart.visible_ratio,0,1)
	else:
		restartval -= 4
		restartval = clamp(restartval,0,125)
		
		restart.visible_ratio -= 0.04
		restart.visible_ratio = clamp(restart.visible_ratio,0,1)
		
	if restartval >= 120:
		restart.add_theme_color_override("font_color",Color("FF0000"))
	else:
		restart.add_theme_color_override("font_color",Color("FFFFFF"))
		
	if restartval >= 125:
		
		if restart.text == "Ending Level...":
			SceneChanger.loadlevel("res://levels/title.tscn")
			
			DATA.newlevel()
			DATA.newlevel_full()
			black.color = Color("#000000FF")
			dead = true
			
		else:
			SceneChanger.loadlevel(get_tree().current_scene.scene_file_path)
			
			DATA.newlevel()
			DATA.newlevel_full()
			black.color = Color("#000000FF")
			dead = true
			
		SceneChanger.switch_to_current()
	
	if Input.is_action_just_pressed("Mark") and !dead and !DATA.seen and get_collision_layer_value(3):
		if tomark != null:
			if (DATA.marked[tomark.marked_index] == false):
				mark_sound.play()
			
			DATA.marked[tomark.marked_index] = true
			
	
	
	if Input.is_action_just_pressed("Freeze") and !dead:

		var tiledata = tile_map_layer.get_cell_tile_data(playercell)


		if tiledata != null:
			if (len(void_collision.get_overlapping_bodies()) <= 1) and (camfrozen == true) and tiledata.get_custom_data("CanUnfreeze"):
				$FreezeSound.pitch_scale = 0.75
				$FreezeSound.play()
				camfrozen = false
				sprite.material.set_shader_parameter("apply",false)
			else:
				$FreezeSound.pitch_scale = 1
				$FreezeSound.play()
				camfrozen = true
				sprite.material.set_shader_parameter("apply",true)
		else:
			if !((len(void_collision.get_overlapping_bodies()) <= 1) and (camfrozen == true)):
				$FreezeSound.pitch_scale = 1
				$FreezeSound.play()
				camfrozen = true
				sprite.material.set_shader_parameter("apply",true)
	
	
	if !dead:
		var inputvec = Input.get_vector("Left","Right","Up","Down") 
			
		var true_dir = wrapi(int(round(inputvec.angle() / (PI / 4))),0,8)
	
		if inputvec != Vector2.ZERO:
			if true_dir < 2:
				sprite.play("Right")
			elif true_dir < 4:
				sprite.play("Down")
			elif true_dir < 6:
				sprite.play("Left")
			elif true_dir < 8:
				sprite.play("Up")
			
		voidpos = inputvec * colldist
	
		void_collision.position = voidpos
	
		if Input.is_action_pressed("Sprint") and sprint_left > 0:
			velocity = inputvec * speed * sprint
			sprite.speed_scale = 1.5
			
		else:
			velocity = inputvec * speed
			sprite.speed_scale = 1
	else:
		velocity = Vector2.ZERO
		
		
	
	
	if velocity == Vector2.ZERO:
		sprite.frame = 0
	
	
	move_and_slide()
	
	
	if world.fuck:
		dead = false


func _on_when_frozen_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("PlayerArea"):
		set_collision_layer_value(3,true)
		set_collision_mask_value(1,true)


func _on_when_frozen_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlayerArea"):
		set_collision_layer_value(3,false)
		set_collision_mask_value(1,false)


func _on_sprint_timer_timeout() -> void:
	if Input.is_action_pressed("Sprint") and !dead:
		sprint_left -= 1
		sprint_bar.size.x -= 1.1379
	else:
		sprint_left += 1
		sprint_bar.size.x += 1.1379
		
	sprint_left = clamp(sprint_left,0,sprintmax)
	sprint_bar.size.x = clamp(sprint_bar.size.x,0,58)
	
	$SprintTimer.start()


func _on_mark_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Markable"):
		tomark = body


func _on_mark_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Markable"):
		tomark = null


func _on_stop_watch_timeout() -> void:
	
	if !dead:
		stopwatch_val += 1
	$StopWatch.start()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Markable") and body.state > 1 and (DATA.marked).count(true) != len(DATA.marked) and get_collision_layer_value(3):
		
		world.died()
		
		DATA.save_data["deaths"] += 1
		
		if !death_sound.playing:
			death_sound.play()
		death_timer.start()
		dead = true
		DATA.newlevel()
		
		player.global_position = Vector2(9999,9999)
		black.color = Color("#000000FF")
		
		world.end_music()


func _on_death_timer_timeout() -> void:
	SceneChanger.switch_to_current()


func _on_black_anim_animation_finished(anim_name: StringName) -> void:
	if (DATA.marked).count(true) != len(DATA.marked):
		dead = false
		world.start_music()
	elif !world.fuck:
		
		DATA.level_to_go = world.next_level
		
		SceneChanger.loadlevel("res://levels/score.tscn")
		SceneChanger.switch_to_current()


func _on_stuck_timer_timeout() -> void:
	if stuck:
		
		var playerpos = global_position
		var tilemaplocal = tile_map_layer.to_local(playerpos)
		var playercell = tile_map_layer.local_to_map(tilemaplocal)
		
		var offsets = []
		var offset_len = []
		var cur_offset = Vector2i(-4,-4)
		
		for x in range(8):
			for y in range(8):
				cur_offset = Vector2i(-4+x,-4+y)
				var data = tile_map_layer.get_cell_tile_data(playercell + cur_offset)
				
				if data != null:
					if data.get_custom_data("CanUnfreeze"):
						
						offsets.append(cur_offset)
					
		for x in offsets:
			offset_len.append(x.length_squared())
			
		
		var indx = offset_len.find(offset_len.min())
		
		global_position = tile_map_layer.to_global(tile_map_layer.map_to_local(offsets[indx] + playercell))
