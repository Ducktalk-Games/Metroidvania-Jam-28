extends Node

enum MenuState {
	MAIN,
	PAUSE,
	OPTIONS,
	CREDITS,
	GAME
}

var current_menu_state: MenuState = MenuState.MAIN
var current_parent_menu_state: Global.MenuState = Global.MenuState.MAIN

enum Ability {
	POCKET_WATCH,
	SCISSORS
}

const ITEM_POPUP = 					preload("res://ui/item_popup.tscn")

# TODO Assign this to pocket watch scene
const POCKETWATCH = 				preload("res://assets/duck_demo/SM_Duck.glb")

const POCKET_WATCH_FLAVOUR_TEXT = 	preload("res://dialogues/pocket_watch_flavour_text.dialogue")

# TODO Assign this to scissors scene
const SCISSORS = 					preload("res://assets/chair/SM_Chair.glb")

const SCISSORS_FLAVOUR_TEXT = 		preload("res://dialogues/scissors_flavour_text.dialogue")

var stage: Stage


func spawn_item_popup(item: Ability) -> ItemPopup:
	var item_popup := ITEM_POPUP.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as ItemPopup

	match item:
		Ability.POCKET_WATCH:
			item_popup.item = POCKETWATCH
			item_popup.flavour_text = POCKET_WATCH_FLAVOUR_TEXT

		Ability.SCISSORS:
			item_popup.item = SCISSORS
			item_popup.flavour_text = SCISSORS_FLAVOUR_TEXT

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
