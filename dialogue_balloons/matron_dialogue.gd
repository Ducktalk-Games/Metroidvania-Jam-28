extends DialogueContainer

const ACT_1_MATRON = preload("res://dialogues/act_1_matron.dialogue")
signal act_1_ended


func _on_main_menu_curtains_opened() -> void:
	await get_tree().create_timer(1.0).timeout
	show_dialogue(ACT_1_MATRON)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource == ACT_1_MATRON:
		act_1_ended.emit()
