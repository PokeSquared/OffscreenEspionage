extends Camera2D


@onready var center_pivot: Node2D = $"../../CenterPivot"
@onready var mask: Node2D = $"../../Mask"
@onready var bg: ColorRect = $"../../BG"
@onready var mask_collision: Node2D = $"../../Mask/Mask Collision"
@onready var mask_border: Node2D = $"../../MaskBorder"
@onready var player: CharacterBody2D = $".."

var zoomin = 1.5
var zoominarea = 1.5

var zoomval = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.visible = true
	mask.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (!player.camfrozen):
	
		if Input.is_action_just_pressed("ZoomIn"):
			zoomin -= 0.12
			zoominarea -= 0.12
			zoomval += 1
			
		if Input.is_action_just_pressed("ZoomOut"):
			zoomin += 0.12
			zoominarea += 0.12
			zoomval -= 1
			
		if Input.is_action_pressed("ZoomIn"):
			zoomin -= 0.12
			zoominarea -= 0.12
			zoomval += 1
			
		if Input.is_action_pressed("ZoomOut"):
			zoomin += 0.12
			zoominarea += 0.12
			zoomval -= 1
		
	zoomin = clamp(zoomin,0.7,1.5)
	zoominarea = clamp(zoominarea,0.7,1.5)
	zoomval = clamp(zoomval,0,8)
	
	mask.scale = Vector2(zoomin,zoomin)
	mask_collision.scale = Vector2( (1/zoomin), (1/zoomin))
	center_pivot.scale = Vector2(zoominarea,zoominarea)
	
	bg.global_position = Vector2(get_screen_center_position().x-600,get_screen_center_position().y-350)
	
	center_pivot.global_position = Vector2(get_screen_center_position().x + zoomval / 2,get_screen_center_position().y + zoomval / 2)
	
	mask.global_position = Vector2(get_screen_center_position().x+8,get_screen_center_position().y+8)
	mask_border.global_position = Vector2(get_screen_center_position().x+8,get_screen_center_position().y+8)
