extends Interactable

@export var animation_player: AnimationPlayer

var player_og_quat: Quaternion

var no_scissors_dialogue: DialogueResource = preload("res://dialogues/no_scissors_narrator.dialogue")


func _on_interacted(interactor: StageCharacter) -> void:
	player_og_quat = Quaternion(interactor.character_mesh.global_basis)
	var can_loot: CanLoot = Component.find(Global.stage.stage_body, "CanLoot") as CanLoot
	Global.disable_player_input()
	move_to_door(interactor)
	rotate_to_door(interactor.character_mesh)

	if can_loot and Global.Ability.SCISSORS in can_loot.inventory:
		animation_player.play("CutOpen")

		# TODO Play walking forward anim but facing backwards to the audience
		get_tree().create_timer(3.5).timeout.connect(curtains_fall.bind(interactor))
	else:
		Global.narrator_bubble.show_dialogue(no_scissors_dialogue)


func curtains_fall(body: StageCharacter) -> void:
	body.curtain_anim_player.play("close_curtain")


func move_to_door(body: StageCharacter) -> PropertyTweener:
	var stage_body_glob_pos := Global.stage.stage_body.global_position
	return get_tree()\
		.create_tween()\
		.tween_property(
			body,
			"global_position",
			Vector3(global_position.x, stage_body_glob_pos.y, stage_body_glob_pos.z),
			1.0)


func rotate_to_door(body_mesh: Node3D) -> MethodTweener:
	return get_tree()\
		.create_tween()\
		.tween_method(
			func(delta: float) -> void:
				var b := Basis(player_og_quat.slerp(Quaternion(Vector3.UP, PI), delta))
				body_mesh.global_basis = b, 0.0, 1.0, 1.0)
