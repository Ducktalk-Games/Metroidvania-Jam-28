extends Area3D


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is StageCharacter:
		body.can_die.die()
