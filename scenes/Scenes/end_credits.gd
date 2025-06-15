extends Control

@export var name_control: Control
@export var name_ap: AnimationPlayer

var name_labels: Array[Label] = []


func _ready() -> void:
	for node in name_control.get_children():
		var name_label: Label = node
		name_labels.append(name_label)


func name_show() -> void:
	if name_labels:
		name_labels[0].show()
		if name_labels.size() > 0:
			name_ap.play("fade_in_and_out")


func _on_name_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in_and_out":
		name_labels[0].hide()
		name_labels.remove_at(0)
		name_show()

	if name_labels.is_empty():
		Global.reset_to_title()
