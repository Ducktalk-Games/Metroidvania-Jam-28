class_name CanRespawn
extends Component

var last_respawn: Vector3
var current_checkpoint: CheckPoint

@onready var stageBody: Character = get_object()

#How much do we have to go below the Y axis before the character is considered for respawn
@export var fall_death_offset: float = -25.0


func _process(delta: float) -> void:
	check_offset_death()


func check_offset_death() -> void:
	if (stageBody.global_position.y <= fall_death_offset):
		on_die()


func on_die() -> void:
	var character: Character = get_object() as Character
	get_tree().create_tween().tween_property(
		character, "global_position", current_checkpoint.global_position, 1.0
		)
