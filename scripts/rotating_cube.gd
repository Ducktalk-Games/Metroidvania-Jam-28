extends MeshInstance3D

func _process(delta: float) -> void:
	rotate(Vector3.UP, delta)
