extends Component

var character: Character


func _node_ready() -> void:
	character = get_object() as Character


func _on_can_receive_input_interact_pressed(just_pressed: bool) -> void:
	if just_pressed and character.nearby_interactable:
		character.nearby_interactable.interacted.emit()
