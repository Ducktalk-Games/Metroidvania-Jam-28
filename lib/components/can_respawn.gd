class_name CanRespawn
extends Component

var current_checkpoint: CheckPoint
var resetting: bool = false

@onready var stageBody: Character = get_object()


func respawn() -> void:
	resetting = true
	Global.disable_player_input()
	var character: Character = get_object() as Character
	get_tree()\
		.create_tween()\
		.tween_property(character, "global_position", current_checkpoint.global_position, 1.0)\
		.finished.connect(func() -> void: resetting = false; Global.enable_player_input(); print("FINISHED"))

	current_checkpoint.reset_all()
