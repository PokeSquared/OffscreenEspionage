extends CharacterBody2D


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var cone_sight: Area2D = $ConeSight
@onready var conecoll: CollisionPolygon2D = $ConeSight/CollisionPolygon2D
@onready var timer: Timer = $Timer
@onready var state_3_area: Area2D = $State3Area
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var wait_to_change: Timer = $WaitToChange
@onready var state3coll: CollisionShape2D = $State3Area/CollisionShape2D
@onready var change_to_idle: Timer = $ChangeToIdle
@onready var pos_wait: Timer = $PosWait
@onready var targetcolor: ColorRect = $Target
@onready var cone: Polygon2D = $Cone
@onready var draw_cone_area: Area2D = $DrawConeArea
@onready var world: Node2D = $"../.."
@onready var player: CharacterBody2D = $"../../Player"
@onready var seen_sound: AudioStreamPlayer2D = $SeenSound
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var twotothree: Timer = $twotothree

@export var speed = 160
@export var state = 0


@export var positions: Array[Vector2] = [Vector2.ZERO]
@export var poswait = 1
@export var startdir = 0
@export var color = Color("#FF0000")



var posindex = 0
var startpos = Vector2.ZERO

var sq_index = 0
var marked_index = 0

var target = null

var playedseen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GuardColor.color = color
	
	if speed == 250:
		sprite.material.set_shader_parameter("apply",true)
	
	startpos = global_position
	
	pos_wait.wait_time = poswait
	
	sq_index = DATA.sq_append(false)
	marked_index = DATA.mark_append(false)
	
	cone_sight.rotation = deg_to_rad(startdir)
	draw_cone_area.rotation = deg_to_rad(startdir)
	


func _physics_process(delta: float) -> void:
	
	if velocity == Vector2.ZERO:
		sprite.frame = 0
	
	
	var true_dir = wrapi(int(round(cone.rotation / (PI / 4))),0,8)
	
	if true_dir < 2:
		sprite.play("Down")
	elif true_dir < 4:
		sprite.play("Left")
	elif true_dir < 6:
		sprite.play("Up")
	elif true_dir < 8:
		sprite.play("Right")
	
	
	if state == 1 and timer.is_stopped() and !player.dead:
		
		if (ray_cast_2d.get_collider() != null):
			if ((ray_cast_2d.get_collider()).is_in_group("Player")):
				
				state = 2
				
				twotothree.start()
				
				world.seen()
				
				DATA.save_data["seen"] += 1
				
				cone_sight.rotation = global_position.direction_to(target).angle() - (deg_to_rad(90))
				cone.rotation = global_position.direction_to(target).angle() - (deg_to_rad(90))
				draw_cone_area.rotation = global_position.direction_to(target).angle() - (deg_to_rad(90))
				
				if (!playedseen):
					seen_sound.play()
					playedseen = true
	
	
	if state > 1 and timer.is_stopped() and len(DATA.squeue) > 0:
		DATA.squeue[sq_index] = true
	
	if state <= 1 and timer.is_stopped() and len(DATA.squeue) > 0:
		DATA.squeue[sq_index] = false
	
	
	targetcolor.global_position = nav_agent.target_position - Vector2(5,5)
		
	if nav_agent.is_navigation_finished() and pos_wait.is_stopped():
		pos_wait.start()
		
		
		
	if timer.is_stopped() and ((state == 4) or (state == 3)):
		cone_sight.rotation = ((-ray_cast_2d.target_position).normalized().angle()) - (deg_to_rad(90))
		cone.rotation = ray_cast_2d.target_position.normalized().angle() - (deg_to_rad(90))
		draw_cone_area.rotation = ray_cast_2d.target_position.normalized().angle() - (deg_to_rad(90))
		
		
	if timer.is_stopped() and state < 3:
		cone.rotation = cone_sight.rotation
		draw_cone_area.rotation = cone.rotation
		

	
	
	if (state == 4) and timer.is_stopped():
		for x in state_3_area.get_overlapping_bodies():
			
			if x.is_in_group("Player"):
				ray_cast_2d.target_position = ray_cast_2d.to_local(x.global_position)
	
	if (state == 3) and timer.is_stopped():
		
		if (ray_cast_2d.get_collider() != null):
			if (!(ray_cast_2d.get_collider()).is_in_group("Player")) and wait_to_change.is_stopped():
				
				wait_to_change.start()
		
		for x in state_3_area.get_overlapping_bodies():
			
			if x.is_in_group("Player"):
				
				nav_agent.target_position = x.global_position
				ray_cast_2d.target_position = ray_cast_2d.to_local(x.global_position)

		

	
	if (state == 2) and timer.is_stopped():
		
		nav_agent.target_position = target
		
		
	
	if not nav_agent.is_navigation_finished():
		
		var next_pos = nav_agent.get_next_path_position()
		velocity = global_position.direction_to(next_pos) * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


	if timer.is_stopped():
		timer.start()



func _on_cone_sight_body_entered(body: Node2D) -> void:

	if body.is_in_group("Player") and state != 2 and state != 3  and state != 4:
		target = body.global_position 
		
		ray_cast_2d.target_position = ray_cast_2d.to_local(body.global_position)
		change_to_idle.start()
		
		state = 1


func _on_cone_sight_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and state == 2:
		state = 3
		


func _on_wait_to_change_timeout() -> void:
	
	if (ray_cast_2d.get_collider() != null):
	
		if (!(ray_cast_2d.get_collider()).is_in_group("Player")):
			
			nav_agent.target_position = global_position
				
			velocity = Vector2.ZERO
			
			change_to_idle.start() 
			
			state = 4
			
			playedseen = false


func _on_change_to_idle_timeout() -> void:
	
	if state == 4 or state == 1:
		
		state = 0


func _on_pos_wait_timeout() -> void:
	if state == 0 and positions.size() > 0:
		
		posindex = (posindex + 1) % positions.size()
		nav_agent.target_position = positions[posindex] + startpos
		
		if (positions.size() > 1):
			cone_sight.rotation = (global_position.direction_to(nav_agent.target_position)).angle() - (deg_to_rad(90))
		else:
			
			cone_sight.rotation = deg_to_rad(startdir)



func _on_navigation_agent_2d_navigation_finished() -> void:
	pass # Replace with function body.


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.


func _on_twotothree_timeout() -> void:
	if state == 2:
		state = 3
