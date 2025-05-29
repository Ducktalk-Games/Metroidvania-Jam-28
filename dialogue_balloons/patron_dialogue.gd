extends DialogueContainer

const ACT_3_PATRON = preload("res://dialogues/act_3_patron.dialogue")
signal patron_spoke


func _on_matron_dialogue_bubble_act_1_ended() -> void:
	show_dialogue(ACT_3_PATRON)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	if resource == ACT_3_PATRON:
		patron_spoke.emit()
