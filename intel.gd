extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var pickup: AudioStreamPlayer = $Pickup
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("bob")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		DATA.gained_intel += 1
		pickup.play()
		sprite_2d.visible = false
		collision_shape_2d.call_deferred("set_disabled",true)


func _on_pickup_finished() -> void:
	queue_free()
