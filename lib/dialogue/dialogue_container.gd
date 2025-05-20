class_name DialogueContainer
extends Sprite3D

@onready var popup_balloon: DialogueManagerExampleBalloon = %PopupBalloon


func _ready() -> void:
	show_dialogue(load("res://dialogues/test_dialogue.dialogue"))


# Shows the balloon dialogue
func show_dialogue(resource: DialogueResource) -> DialogueManagerExampleBalloon:
	return DialogueManager.show_dialogue_balloon_scene(popup_balloon, resource)


# Goes to next line
func next_line() -> void:
	popup_balloon.next(popup_balloon.dialogue_line.next_id)
