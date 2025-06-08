@tool
extends BoxTrigger

@export var level: PackedScene


func _stage_body_entered(_body: StageCharacter) -> void:
	Global.curtains_fall(level)
