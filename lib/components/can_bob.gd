extends Component

@export var speed := 1.0
@export var attenuation := 0.2

@onready var bobbing_mesh := get_object() as Node3D

var time_elapsed := 0.0


func _process(delta: float) -> void:
	time_elapsed = fmod((time_elapsed + delta) * speed, TAU)
	bobbing_mesh.global_position = Vector3(0.0, sin(time_elapsed) * attenuation, 0.0)
