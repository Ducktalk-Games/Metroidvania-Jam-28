extends DialogueContainer

const ACT_3_PATRON = preload("res://dialogues/act_3_patron.dialogue")


func _on_matron_dialogue_bubble_act_1_ended() -> void:
	show_dialogue(ACT_3_PATRON)
