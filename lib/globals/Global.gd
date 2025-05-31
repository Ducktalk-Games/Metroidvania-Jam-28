extends Node

enum MenuState {
	MAIN,
	PAUSE,
	OPTIONS,
	CREDITS,
	GAME
}

enum Ability {
	POCKET_WATCH,
	SCISSORS
}

var kill_dialog: bool
var current_menu_state: MenuState = MenuState.MAIN
var current_parent_menu_state: Global.MenuState = Global.MenuState.MAIN

var stage: Stage

const ITEM_POPUP = preload("res://ui/item_popup.tscn")

var dialogue_mgr: DialogueMgr


func _ready() -> void:
	dialogue_mgr = DialogueMgr.new()
	add_child(dialogue_mgr)


func spawn_item_popup(item: Ability) -> ItemPopup:
	var item_popup := ITEM_POPUP.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as ItemPopup
	item_popup.ability = item
	add_child(item_popup)
	return item_popup


func disable_player_input() -> void:
	if stage:
		var can_receive_input := Component.find(stage.current_body, "CanReceiveInput") as CanReceiveInput
		can_receive_input.disable()


func enable_player_input() -> void:
	if stage:
		var can_receive_input := Component.find(stage.current_body, "CanReceiveInput") as CanReceiveInput
		can_receive_input.enable()
