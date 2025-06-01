class_name DialogueContainer
extends Sprite3D

@export var debug := false

const FLOATING_BALLOON = preload("res://dialogue_balloons/floating_balloon.tscn")
var popup_balloon: DialogueManagerExampleBalloon


func _ready() -> void:
	DialogueSequencer.set(get_parent().name.to_lower() + "_bubble", self)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueSequencer.show_dialog.connect(_handle_dialog)


func _handle_tags(tags: PackedStringArray) -> void:
	for tag: String in tags:
		match tag:
			"angry":
				#do animation things/maybe popup borders?
				pass

			_:
				printerr("Got uncaught tag: ", tag)


func _handle_dialog(cont: DialogueContainer = null, line: DialogueLine = null) -> void:

	if cont == self:
		if not popup_balloon:
			popup_balloon = FLOATING_BALLOON.instantiate()
			$SubViewport.add_child(popup_balloon)

		_handle_tags(line.tags)
		popup_balloon.dialogue_line = line
	elif popup_balloon:
		popup_balloon.queue_free()


func _on_dialogue_ended(_resource: DialogueResource) -> void:
	_handle_dialog()
