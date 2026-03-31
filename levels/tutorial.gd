extends Label

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = false
	
	if len(area_2d.get_overlapping_bodies()) > 0:
		
		for x in area_2d.get_overlapping_bodies():
			if x.is_in_group("Player"):
				visible = true
			
	
