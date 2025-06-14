@tool
extends BoxTrigger

@export var performance_level: PackedScene


func _stage_body_entered(body: StageCharacter) -> void:
	Global.curtains_fall(performance_level)
