class_name DialogueContainer
extends Sprite3D

@onready var popup_balloon: DialogueManagerExampleBalloon = %PopupBalloon

@export var debug := false


func _ready() -> void:
	if debug:
		show_dialogue(load("res://dialogues/test_dialogue.dialogue"))

# Shows the balloon dialogue
func show_dialogue(resource: DialogueResource) -> DialogueManagerExampleBalloon:
	return DialogueManager.show_dialogue_balloon_scene(popup_balloon, resource)
