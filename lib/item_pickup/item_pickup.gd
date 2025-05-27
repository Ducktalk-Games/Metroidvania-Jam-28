extends Interactable
class_name ItemPickup

@export var ability: Global.Ability


func _on_body_entered(body: Node3D) -> void:
	if body is Character:
		body.nearby_item = self


func _on_body_exited(body: Node3D) -> void:
	if body is Character:
		body.nearby_item = null
