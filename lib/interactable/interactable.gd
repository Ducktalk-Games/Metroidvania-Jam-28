extends Area3D
class_name Interactable

signal character_entered
signal character_exited

signal interacted(interactor: Character)


func _on_body_entered(body: Node3D) -> void:
	if body is Character:
		body.nearby_interactable = self
		body.key_dialog._on_item_pickup_body_entered(body)


func _on_body_exited(body: Node3D) -> void:
	if body is Character:
		body.nearby_interactable = null
		body.key_dialog._on_item_pickup_body_exited(body)
