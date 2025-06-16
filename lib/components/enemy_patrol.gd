class_name EnemyPatrol

extends Component

@export
var patrol_speed: float = 10.0

@export
var end_of_path_delay: float = 0.1

@onready
var patrol_agent := get_object() as CharacterBody3D

@export
var point_a: Node3D

@export
var point_b: Node3D

var patrol_tween: Tween


func _ready() -> void:

	var point_a_pos := point_a.global_position
	var point_b_pos := point_b.global_position

	patrol_tween = get_tree().create_tween().set_loops()
	patrol_tween.tween_property(patrol_agent, "global_position", point_b_pos, patrol_speed)
	patrol_tween.tween_property(patrol_agent, "global_rotation", Vector3.UP * PI, end_of_path_delay).as_relative()
	patrol_tween.tween_property(patrol_agent, "global_position", point_a_pos, patrol_speed)
	patrol_tween.tween_property(patrol_agent, "global_rotation", Vector3.UP * PI, end_of_path_delay).as_relative()


func _exit_tree() -> void:
	patrol_tween.kill()
	super._exit_tree()
