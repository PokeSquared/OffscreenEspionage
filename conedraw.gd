extends Polygon2D

@onready var cone_anim: AnimationPlayer = $ConeAnim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_draw_cone_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Tilemap"):
		cone_anim.play("fade_out")


func _on_draw_cone_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Tilemap"):
		cone_anim.play("fade_in")
