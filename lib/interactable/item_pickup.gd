@tool
extends Interactable
class_name ItemPickup

@export var item: MeshInstance3D
@export var ability: Global.Ability:
	set(value):
		if not item: return
		match value:
			Global.Ability.POCKET_WATCH:
				item.mesh = preload("uid://cpxnqocqxcsyb")

			Global.Ability.SCISSORS:
				item.mesh = preload("uid://bftytufqh0ov5")

		ability = value


func _on_body_entered(body: Node3D) -> void:
	if Engine.is_editor_hint(): return
	super._on_body_entered(body)
	if body is StageCharacter:
		body.nearby_item = self


func _on_body_exited(body: Node3D) -> void:
	if Engine.is_editor_hint(): return
	super._on_body_exited(body)
	if body is StageCharacter:
		body.nearby_item = null
