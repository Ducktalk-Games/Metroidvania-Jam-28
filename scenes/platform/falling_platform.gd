extends RigidBody3D

@onready var platform_animation: AnimationPlayer = %PlatformAnimation
@onready var original_object_pos := global_position

# This variable only exists because the current animation statement
# returns true twice in _integrate_forces
var object_resetting := false


# When the player steps on the plaform
func _on_hit_detection_body_entered(body: Node3D) -> void:
	if body is Character and not object_resetting:
		platform_animation.play("fall")


# Overriding this is the godot way of **properly** changing a rigid body's position
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if platform_animation.current_animation == "RESET" and not object_resetting:
		object_resetting = true
		get_tree()\
			.create_tween()\
			.tween_property(self, "global_position", original_object_pos, .8)\
			.set_trans(Tween.TRANS_SINE)\
			.finished.connect(func() -> void: object_resetting = false)
