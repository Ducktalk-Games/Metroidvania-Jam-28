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
var current_platform_level: PlatformLevel
var target_scene: PackedScene
var target_platform_level: PlatformLevel

const ITEM_POPUP = preload("res://ui/item_popup.tscn")


func spawn_item_popup(item: Ability) -> ItemPopup:
	var item_popup := ITEM_POPUP.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as ItemPopup
	item_popup.ability = item
	add_child(item_popup)
	return item_popup


func disable_player_input() -> void:
	for body: Character in [stage.player_child_body, stage.stage_body]:
		if body:
			var can_receive_input := Component.find(body, "CanReceiveInput") as CanReceiveInput
			can_receive_input.disable()


func enable_player_input() -> void:
	for body: Character in [stage.player_child_body, stage.stage_body]:
		if body:
			var can_receive_input := Component.find(body, "CanReceiveInput") as CanReceiveInput
			can_receive_input.enable()


func curtains_fall(house_level: PackedScene) -> void:
	target_scene = house_level
	stage.stage_body.curtain_anim_player.play("close_curtain")
	stage.stage_body\
		.curtain_anim_player\
		.animation_finished\
		.connect(_on_curtains_fall)


func _on_curtains_fall(_animation: String) -> void:
	stage.stage_body.curtain_anim_player.animation_finished.disconnect(_on_curtains_fall)
	_change_level_and_open_curtains()


func _change_level_and_open_curtains() -> void:
	current_platform_level.queue_free()
	var to_node: Node3D = target_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	to_node.ready.connect(_curtains_rise)
	stage.add_child(to_node)


func _curtains_rise() -> void:
	stage.stage_body.curtain_anim_player.play("close_curtain", -1, -1.0, true)
	stage.stage_body.curtain_anim_player.animation_finished.connect(_on_curtains_opened)


func _on_curtains_opened(_animation: String) -> void:
	stage.stage_body.curtain_anim_player.animation_finished.disconnect(_on_curtains_opened)
	enable_player_input()


func dim_lights_and_spotlight_narrator(dim: bool = true) -> void:

	if dim:
		stage.stage_body.curtain_anim_player.play("dim_lights_show_narrator")
	else:
		stage.stage_body.curtain_anim_player.play("hide_narrator")

	await stage.stage_body.curtain_anim_player.animation_finished
