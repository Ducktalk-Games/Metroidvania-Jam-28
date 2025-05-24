@tool
extends VATMultiMeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_instance_animation_offset(0, 0.0)
	update_instance_track(0, 0)
	update_instance_alpha(0, 1.0)
	multimesh.set_instance_transform(0, Transform3D.IDENTITY)
