extends Interactable

@export var animation_player: AnimationPlayer

var player_og_quat: Quaternion

var no_scissors_dialogue: DialogueResource = preload("res://dialogues/no_scissors_narrator.dialogue")


func _ready() -> void:
	super._ready()
	player_og_quat = Quaternion(%PlayerChildMesh.global_basis)


func _on_interacted() -> void:
	var can_loot: CanLoot = Component.find(Global.stage.stage_body, "CanLoot") as CanLoot
	Global.disable_player_input()
	move_to_door()
	rotate_to_door()

	if can_loot and Global.Ability.SCISSORS in can_loot.inventory:
		animation_player.play("CutOpen")
		
		# TODO Play walking forward anim but facing backwards to the audience
		get_tree().create_timer(1.0).timeout.connect(curtains_fall)
	else:
		Global.narrator_bubble.show_dialogue(no_scissors_dialogue)

func curtains_fall() -> void:
	pass

func move_to_door() -> PropertyTweener:
	var stage_body_glob_pos := Global.stage.stage_body.global_position
	return get_tree()\
		.create_tween()\
		.tween_property(
			Global.stage.stage_body,
			"global_position",
			Vector3(global_position.x, stage_body_glob_pos.y, stage_body_glob_pos.z),
			1.0)


func rotate_to_door() -> MethodTweener:
	return get_tree()\
		.create_tween()\
		.tween_method(
			func(delta: float) -> void:
				var b := Basis(player_og_quat.slerp(Quaternion(Vector3.UP, PI), delta))
				%PlayerChildMesh.global_basis = b, 0.0, 1.0, 1.0)
