extends Node

var narrator_bubble: DialogueContainer
var matron_bubble: DialogueContainer
var patron_bubble: DialogueContainer
var player_bubble: DialogueContainer

var current_dialogue: DialogueResource = null

var next_dialog_id: String = "start"

signal dialogue_finished_typing()
var dialog_ready: bool = true

signal show_dialog(cont: DialogueContainer, line: DialogueLine)


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	dialogue_finished_typing.connect(_on_finished_typing)


func _on_finished_typing() -> void:
	dialog_ready = true


func _on_dialogue_ended(_res: DialogueResource) -> void:
	print("dialogue_end")
	current_dialogue = null


func set_dialogue_resource(res_path: String) -> DialogueSequencer:
	var res: DialogueResource = load(res_path)
	current_dialogue = res
	return self


func start_dialog(res_path: String) -> DialogueSequencer:
	if Global.kill_dialog: return
	Global.disable_player_input()
	#Enable if you want to not allow pausing whilst dialog is playing
	#Global.can_pause_game = false
	var mgr := set_dialogue_resource(res_path)
	next_dialog_id = ""
	mgr._process_dialogue()
	return mgr


func _process_dialogue() -> void:
	dialog_ready = false
	var line := await current_dialogue.get_next_dialogue_line(next_dialog_id)

	if not line:
		show_dialog.emit(null, null)
		return

	next_dialog_id = line.next_id

	var bubble: DialogueContainer = get(line.character.to_lower()+"_bubble")

	if bubble:
		show_dialog.emit(bubble, line)


func _input(_event: InputEvent) -> void:
	var has_to_process_dialog: bool = Input.is_action_just_pressed("next_line")
	var paused_menus: Array[Global.MenuState] = [Global.MenuState.OPTIONS, Global.MenuState.MAIN, Global.MenuState.CREDITS]
	var is_paused: bool = Global.current_menu_state in paused_menus || Global.lock_dialogue_input

	if has_to_process_dialog && current_dialogue && dialog_ready && !is_paused:
		_process_dialogue()
