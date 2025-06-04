@tool
extends Interactable
class_name ItemPickup

@onready var item: MeshInstance3D = %ItemMesh
@export var ability: Global.Ability:
	set(value):
		match value:
			Global.Ability.POCKET_WATCH:
				item.mesh = load("res://assets/fugit_watch/SM_Item_Fugit_watch_Plane_019.res")

			Global.Ability.SCISSORS:
				item.mesh = load("res://assets/duck_demo/SM_Duck_Plane_001.res")

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
