extends Area3D
class_name Interactable

signal character_entered
signal character_exited


func _on_body_entered(body: Node3D) -> void:
	if body is Character:
		body.nearby_interactable = self


func _on_body_exited(body: Node3D) -> void:
	if body is Character:
		body.nearby_interactable = null
