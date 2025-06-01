class_name ItemPopup
extends Control

var ability: Global.Ability
var item: PackedScene
var flavour_text: DialogueResource
var narrator_blurb: DialogueResource

var balloon: DialogueManagerExampleBalloon

# TODO Assign this to pocket watch scene
const POCKETWATCH = preload("res://assets/duck_demo/SM_Duck.glb")

const POCKET_WATCH_FLAVOUR_TEXT: DialogueResource = (
	preload("res://dialogues/pocket_watch_flavour_text.dialogue")
	)

const POCKETWATCH_NARRATOR_BLURB: DialogueResource = (
	# 030_player_finds_pocketwatch
	preload("uid://dqs7hvx6lukw4")
	)

# TODO Assign this to scissors scene
const SCISSORS = preload("res://assets/chair/SM_Chair.glb")

const SCISSORS_FLAVOUR_TEXT = preload("res://dialogues/scissors_flavour_text.dialogue")

const SCISSORS_NARRATOR_BLURB: DialogueResource = (
	# 050_player_finds_scissors
	preload("uid://c4r8sbpmeje6n")
	)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_line") and balloon:
		balloon.next_line()


func _ready() -> void:
	match ability:
		Global.Ability.POCKET_WATCH:
			item = POCKETWATCH
			flavour_text = POCKET_WATCH_FLAVOUR_TEXT
			narrator_blurb = POCKETWATCH_NARRATOR_BLURB

		Global.Ability.SCISSORS:
			item = SCISSORS
			flavour_text = SCISSORS_FLAVOUR_TEXT
			narrator_blurb = SCISSORS_NARRATOR_BLURB

	%ItemParent.add_child(item.instantiate())
	balloon = DialogueManager.show_dialogue_balloon_scene(%FlavourTextBalloon, flavour_text)
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)


func _on_dialogue_end(res: DialogueResource) -> void:
	if res == flavour_text:
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_end)
		Global.narrator_bubble.show_dialogue(narrator_blurb)
		queue_free()
