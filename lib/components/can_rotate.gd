extends Component

@export var speed := 1.0

@onready var rotating_mesh := get_object() as Node3D


func _process(delta: float) -> void:
	rotating_mesh.rotate_y(delta)
