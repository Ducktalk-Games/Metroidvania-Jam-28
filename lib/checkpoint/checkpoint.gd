@icon("res://lib/icons/checkpoint-icon.svg")
class_name CheckPoint
extends Area3D


func _on_body_entered(body: Node3D) -> void:
	# Try cast into character
	if not body is Character:
		pass

	var can_respawn: CanRespawn = Component.find(body, "CanRespawn") as CanRespawn

	if can_respawn and can_respawn.current_checkpoint != self:
		can_respawn.current_checkpoint = self
