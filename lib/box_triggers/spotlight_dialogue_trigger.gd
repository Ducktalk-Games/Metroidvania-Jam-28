class_name SpotlightTrigger
extends SimpleDialogueTrigger

@export var spotlight: StageSpotlight


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint(): return
	spotlight.alpha_spotlight(0.0)


func _stage_body_entered(body: StageCharacter) -> void:
	super._stage_body_entered(body)
	if not triggered:
		spotlight.turn_on_spotlight()
