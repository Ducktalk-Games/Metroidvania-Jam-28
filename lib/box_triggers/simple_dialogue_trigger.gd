@tool
class_name SimpleDialogueTrigger
extends BoxTrigger

@export var dialogue_resource: DialogueResource


func _stage_body_entered(body: StageCharacter) -> void:
	assert(dialogue_resource, "No Dialogue resource found in " + name)
	if not triggered:
		DialogueSequencer.start_dialog(dialogue_resource.resource_path)
		triggered = true
