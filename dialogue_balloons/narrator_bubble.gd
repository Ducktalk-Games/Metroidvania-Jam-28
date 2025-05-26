extends DialogueContainer

const ACT_4_NARRATOR = preload("res://dialogues/act_4_narrator.dialogue")
signal act_4_finished


func _on_patron_dialogue_bubble_patron_spoke() -> void:
	show_dialogue(ACT_4_NARRATOR)


func _on_dialogue_ended(resource: DialogueResource) -> void:
	match resource:
		ACT_4_NARRATOR:
			act_4_finished.emit()
