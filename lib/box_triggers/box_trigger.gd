@tool
class_name BoxTrigger
extends Area3D

@onready var trigger_label: Label3D = %TriggerLabel
@export var label_string: String:
	set(value):
		if trigger_label:
			trigger_label.text = value

		label_string = value

var triggered: bool

signal stage_body_entered(body: StageCharacter)


func _ready() -> void:
	if Engine.is_editor_hint(): return
	trigger_label.hide()


func _on_body_entered(body: Node3D) -> void:
	if Engine.is_editor_hint(): return
	if body is StageCharacter:
		_stage_body_entered(body)


func _stage_body_entered(_body: StageCharacter) -> void:
	pass
