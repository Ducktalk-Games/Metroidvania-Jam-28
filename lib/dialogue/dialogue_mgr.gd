class_name DialogueMgr
extends Node

var narrator_bubble: DialogueContainer
var matron_bubble: DialogueContainer
var patron_bubble: DialogueContainer
var playerchildbody_bubble: DialogueContainer

var current_dialogue: DialogueResource = null

var next_dialog_id: String = "start"

signal show_dialog(cont: DialogueContainer, line: DialogueLine)


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _on_dialogue_ended(_res: DialogueResource) -> void:
	current_dialogue = null


func set_dialogue_resource_text(name: String) -> void:
	var res := load("res://dialogues/"+name+".dialogue")
	current_dialogue = res


func set_dialogue_resource_act(number: int) -> void:
	var res := load("res://dialogues/act_"+str(number)+".dialogue")
	current_dialogue = res


func _process_dialogue() -> void:
	var line := await current_dialogue.get_next_dialogue_line(next_dialog_id)

	if not line:
		show_dialog.emit(null, null)
		return

	next_dialog_id = line.next_id

	var bubble: DialogueContainer = get(line.character.to_lower()+"_bubble")

	if bubble:
		show_dialog.emit(bubble, line)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_line") and not current_dialogue == null:
		_process_dialogue()
