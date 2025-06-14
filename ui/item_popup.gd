class_name ItemPopup
extends Control

var ability: Global.Ability
var item: PackedScene
var flavour_text: DialogueResource
var narrator_blurb: DialogueResource

var balloon: DialogueManagerExampleBalloon

const POCKETWATCH = preload("uid://r0osy54kqc35")

const POCKET_WATCH_FLAVOUR_TEXT: DialogueResource = (
	preload("res://dialogues/pocket_watch_flavour_text.dialogue")
	)

# 030_player_finds_pocketwatch
@export var pocketwatch_narrator_blurb: DialogueResource

const SCISSORS = preload("uid://b08myabg8u4sm")

const SCISSORS_FLAVOUR_TEXT = preload("res://dialogues/scissors_flavour_text.dialogue")

# 050_player_finds_scissors
@export var scissors_narrator_blurb: DialogueResource


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_line") and balloon:
		balloon.next_line()


func _ready() -> void:
	match ability:
		Global.Ability.POCKET_WATCH:
			item = POCKETWATCH
			flavour_text = POCKET_WATCH_FLAVOUR_TEXT
			narrator_blurb = pocketwatch_narrator_blurb

		Global.Ability.SCISSORS:
			item = SCISSORS
			flavour_text = SCISSORS_FLAVOUR_TEXT
			narrator_blurb = scissors_narrator_blurb

	%ItemParent.add_child(item.instantiate())
	balloon = DialogueManager.show_dialogue_balloon_scene(%FlavourTextBalloon, flavour_text)
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)


func _on_dialogue_end(res: DialogueResource) -> void:
	if res == flavour_text:
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_end)

		# 030_player_finds_pocketwatch
		DialogueSequencer.start_dialog(narrator_blurb.resource_path)

		var key_dialog: KeyDialog = Global.stage.stage_body.key_dialog
		key_dialog.key_action = [key_dialog.KeyAction.WATCH, key_dialog.KeyAction.SCISSORS][ability]
		key_dialog.pop_in_key()

		queue_free()
