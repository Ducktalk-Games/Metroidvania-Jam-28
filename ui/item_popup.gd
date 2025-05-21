class_name ItemPopup
extends Control

var item: PackedScene
var flavour_text: DialogueResource
var balloon: DialogueManagerExampleBalloon


func _input(event: InputEvent) -> void:
	if balloon:
		balloon._input(event)


func _ready() -> void:
	if flavour_text and item:
		%ItemParent.add_child(item.instantiate())
		balloon = DialogueManager.show_dialogue_balloon_scene(%FlavourTextBalloon, flavour_text)
		DialogueManager.dialogue_ended.connect(_on_dialogue_end)


func _on_dialogue_end(res: DialogueResource) -> void:
	if res == flavour_text:
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_end)
		queue_free()
