class_name CanRespawn
extends Component

var current_checkpoint: CheckPoint
var resetting: bool = false

@onready var stageBody: Character = get_object()


func respawn() -> void:
	if not current_checkpoint: return
	resetting = true
	# player_dies_matron
	DialogueSequencer.start_dialog("uid://1wyveoo4p3km")
	Global.stage.matron.get_angry()
	var character: Character = get_object() as Character
	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_method(func(_delta: float) -> void: Global.disable_player_input(), 0.0, 1.0, 1.0)
	tween.tween_property(character, "global_position", current_checkpoint.global_position, 1.0)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)

	tween.chain().tween_callback(func() -> void: resetting = false; Global.enable_player_input())

	var health := other("HasHealth") as HasHealth

	if health:
		health.reset_health()

	current_checkpoint.reset_all()
