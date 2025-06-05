extends Interactable

@export var animation_player: AnimationPlayer#
@export var current_level: Node3D

const HOUSE_LEVEL: PackedScene = preload("res://scenes/platform/house_level.tscn")

var player_og_quat: Quaternion

var no_scissors_dialogue: DialogueResource = preload("res://dialogues/no_scissors_narrator.dialogue")

var stage_character: StageCharacter


func _on_interacted(interactor: StageCharacter) -> void:
	stage_character = interactor
	player_og_quat = stage_character.character_mesh.global_basis.get_rotation_quaternion()
	var can_loot: CanLoot = Component.find(Global.stage.stage_body, "CanLoot") as CanLoot
	Global.disable_player_input()
	move_to_door()
	rotate_to_door()

	if can_loot and Global.Ability.SCISSORS in can_loot.inventory:
		animation_player.play("CutOpen")

		# TODO Play walking forward anim but facing backwards to the audience
		get_tree().create_timer(3.5).timeout.connect(Global.curtains_fall.bind(HOUSE_LEVEL))
	else:
		DialogueSequencer.start_dialog("uid://cfwpwiwxhnsli")


func move_to_door() -> PropertyTweener:
	var stage_body_glob_pos := Global.stage.stage_body.global_position
	return get_tree()\
		.create_tween()\
		.tween_property(
			stage_character,
			"global_position",
			Vector3(global_position.x, stage_body_glob_pos.y, stage_body_glob_pos.z),
			1.0)


func rotate_to_door() -> MethodTweener:
	return get_tree()\
		.create_tween()\
		.tween_method(
			func(delta: float) -> void:
				var b := Basis(player_og_quat.slerp(Quaternion(Vector3.UP, PI), delta))
				stage_character.character_mesh.global_basis = b, 0.0, 1.0, 1.0)
