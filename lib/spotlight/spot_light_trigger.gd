extends Node3D


func _on_trigger_area_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Character:
		%SpotlightAnim.play("turn_on")
