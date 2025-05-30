@icon("res://lib/icons/checkpoint-icon.svg")
class_name CheckPoint
extends Area3D

var resettables: Array[CanReset]


func _ready() -> void:
	for child in get_children():
		var resettable: CanReset = Component.find(child, "CanReset") as CanReset

		if resettable:
			resettables.append(resettable)


func reset_all() -> void:
	for resetter in resettables:
		resetter.reset()


func _on_body_entered(body: Node3D) -> void:
	# Try cast into character
	if not body is Character:
		pass

	var can_respawn: CanRespawn = Component.find(body, "CanRespawn") as CanRespawn

	if can_respawn and can_respawn.current_checkpoint != self:
		can_respawn.current_checkpoint = self
