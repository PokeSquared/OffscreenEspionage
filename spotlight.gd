extends Node2D

var alert = false
var pos = Vector2.ZERO

@export var spot_scale = 1

@onready var alert_coll: Area2D = $Alert
@onready var texture_rect: TextureRect = $TextureRect
@onready var detect: Area2D = $Detect

@export var positions: Array[Vector2] = [Vector2.ZERO]
@export var speed = 1
var index = 0

var start_pos = Vector2.ZERO

var frame0 = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.scale = spot_scale * Vector2.ONE
	detect.scale = spot_scale * Vector2.ONE
	alert_coll.scale = spot_scale * Vector2.ONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if frame0:
		start_pos = global_position
		frame0 = false

	if len(positions) > 1:
		check_pos()
	
	global_position = global_position.move_toward(positions[index] + start_pos , delta * speed)
	
	
	if alert:
		
		alert = false
		
		for x in alert_coll.get_overlapping_bodies():
			if x.is_in_group("Markable"):
				
				if x.state < 2:
					
					x.target = pos
					x.ray_cast_2d.target_position = x.ray_cast_2d.to_local(pos)
					
					x.state = 2
					
					x.twotothree.start()
					
					x.world.seen()
					
					DATA.save_data["seen"] += 1
					
					x.cone_sight.rotation = x.global_position.direction_to(x.target).angle() - (deg_to_rad(90))
					x.cone.rotation = x.global_position.direction_to(x.target).angle() - (deg_to_rad(90))
					x.draw_cone_area.rotation = x.global_position.direction_to(x.target).angle() - (deg_to_rad(90))
					
					if (!x.playedseen):
						x.seen_sound.pitch_scale = 1.2
						x.seen_sound.play()
						x.playedseen = true
				
				


func _on_detect_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		
		alert = true
		pos = body.global_position
		
		
func check_pos():
	
	if round(global_position) == round(positions[index] + start_pos):
		index += 1
		index = wrap(index,0,len(positions))
