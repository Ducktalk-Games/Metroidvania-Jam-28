class_name CanRespawn
extends Component

var last_respawn: Vector3
var current_checkpoint: CheckPoint

@onready var stageBody: Character = get_object()


func respawn() -> void:
	var character: Character = get_object() as Character
	get_tree()\
		.create_tween()\
		.tween_property(character, "global_position", current_checkpoint.global_position, 1.0)
	current_checkpoint.reset_all()
