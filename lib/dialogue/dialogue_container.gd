class_name DialogueContainer
extends Sprite3D

@export var debug := false

@onready var popup_balloon: DialogueManagerExampleBalloon = %PopupBalloon


func _ready() -> void:
	if debug:
		show_dialogue(load("res://dialogues/test_dialogue.dialogue"))


# Shows the balloon dialogue
func show_dialogue(resource: DialogueResource) -> DialogueManagerExampleBalloon:
	return DialogueManager.show_dialogue_balloon_scene(popup_balloon, resource)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_line") and popup_balloon:
		popup_balloon.next_line()
