@tool
class_name DialogueTrigger
extends Area3D

@onready var trigger_label: Label3D = %TriggerLabel
@export var label_string: String:
	set(value):
		if trigger_label:
			trigger_label.text = value

		label_string = value


func _ready() -> void:
	if Engine.is_editor_hint(): return
	trigger_label.hide()
