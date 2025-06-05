extends RigidBody3D
class_name FallingPlatform

@onready var original_object_pos := global_position

@export var can_reset: CanReset
@export var platform_animation: AnimationPlayer

var is_falling: bool = false


# When the player steps on the plaform	
func _on_hit_detection_body_entered(body: Node3D) -> void:
	print("THIS")
	if body is Character and not is_falling:
		print("Falling")
		is_falling = true
		platform_animation.play("fall")


func reset_platform() -> void:
	get_tree()\
		.create_tween()\
		.tween_property(self, "global_position", original_object_pos, .8)\
		.set_trans(Tween.TRANS_SINE)\
		.finished.connect(func() -> void: is_falling = false)
