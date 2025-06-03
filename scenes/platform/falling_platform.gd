extends RigidBody3D
class_name FallingPlatform

@onready var original_object_pos := global_position

@export var can_reset: CanReset
@export var platform_animation: AnimationPlayer

var fallen: bool = false


# When the player steps on the plaform
func _on_hit_detection_body_entered(body: Node3D) -> void:
	if body is Character and not can_reset.resetting_object:
		platform_animation.play("fall")


# Overriding this is the godot way of **properly** changing a rigid body's position
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if can_reset.resetting_object:
		reset_platform()

func reset_platform() -> void:
	get_tree()\
		.create_tween()\
		.tween_property(self, "global_position", original_object_pos, .8)\
		.set_trans(Tween.TRANS_SINE)\
		.finished.connect(func() -> void: can_reset.resetting_object = false)
