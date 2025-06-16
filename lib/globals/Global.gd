extends Node

enum MenuState {
	MAIN,
	PAUSE,
	TRANSITIONING,
	PERFORMANCE,
	OPTIONS,
	OPTIONS_INGAME,
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
var can_pause_game: bool = true
var patron_animation_tree: PatronAnimationTree
var are_lights_dimmed: bool = false
var is_paused_whilst_lights_dimmed: bool = false
var last_person_on_spotlight: Node3D = null
var who_is_on_spotlight: Node3D = null
var was_input_disabled_before_pause: bool = false
var is_input_disabled: bool = true
var lock_dialogue_input: bool = false

var options_amp: OptionsAmp

const ITEM_POPUP = preload("res://ui/item_popup.tscn")

const STAGE = preload("res://scenes/stage/stage.tscn")

signal curtains_opened


func start_house_level()-> void:
	#Disable attack
	var can_attack: CanAttack = Component.find(stage.stage_body, "CanAttack")
	can_attack.disable()


func start_performance_lock() -> void:
	current_menu_state = Global.MenuState.PERFORMANCE
	disable_player_input()
	can_pause_game = false


func spawn_item_popup(item: Ability) -> ItemPopup:
	var item_popup := ITEM_POPUP.instantiate() as ItemPopup
	item_popup.ability = item
	Global.stage.player_child_body.add_child(item_popup)
	return item_popup


func disable_player_input() -> void:
	for body: Character in [stage.player_child_body, stage.stage_body]:
		if body:
			var can_receive_input: CanReceiveInput = Component.find(body, "CanReceiveInput")
			can_receive_input.disable()
			is_input_disabled = true


func enable_player_input() -> void:
	for body: Character in [stage.player_child_body, stage.stage_body]:
		if body:
			var can_receive_input := Component.find(body, "CanReceiveInput") as CanReceiveInput
			can_receive_input.enable()
			is_input_disabled = false


func curtains_fall(target: PackedScene) -> void:
	Global.disable_player_input()
	Global.current_menu_state = Global.MenuState.TRANSITIONING
	Global.stage.patron.set_music_to("")
	target_scene = target
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
	var to_node: Node = target_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	to_node.ready.connect(_curtains_rise)
	stage.add_child(to_node)


func _curtains_rise() -> void:
	stage.stage_body.curtain_anim_player.play("close_curtain", -1, -1.0, true)
	stage.stage_body.curtain_anim_player.animation_finished.connect(_on_curtains_opened)


func _on_curtains_opened(_animation: String) -> void:
	stage.stage_body.curtain_anim_player.animation_finished.disconnect(_on_curtains_opened)
	enable_player_input()
	Global.current_menu_state = Global.MenuState.GAME
	curtains_opened.emit()


func set_patron_animation_tree(animation_tree: PatronAnimationTree) -> void:
	patron_animation_tree = animation_tree


func dim_lights(dim: bool = true) -> void:
	are_lights_dimmed = dim

	if dim:
		stage.stage_body.curtain_anim_player.play("dim_lights")
	else:
		stage.stage_body.curtain_anim_player.play("show_lights")

	await stage.stage_body.curtain_anim_player.animation_finished


func dim_lights_async(dim: bool = true) -> void:
	are_lights_dimmed = dim

	if dim:
		stage.stage_body.curtain_anim_player.play("dim_lights")
	else:
		stage.stage_body.curtain_anim_player.play("show_lights")


func control_spotlight_async(who: Node3D, switch_on: bool = true, duration: float = 0.2) -> void:
	who_is_on_spotlight = who
	var height_offset: float = 0.0

	match who:
		Global.stage.patron:
			height_offset = 5.686

		Global.stage.narrator:
			height_offset = 7.882

		Global.stage.player_child_body:
			height_offset = 11.2

	stage.spotlight.global_position = who.global_position + Vector3.UP * height_offset

	if switch_on:
		stage.spotlight.turn_on_spotlight(duration).timeout
	else:
		stage.spotlight.turn_off_spotlight(duration).timeout


func control_spotlight(who: Node3D, switch_on: bool = true, duration: float = 0.2) -> void:
	who_is_on_spotlight = who
	var height_offset: float = 0.0

	match who:
		Global.stage.patron:
			height_offset = 5.686

		Global.stage.narrator:
			height_offset = 7.882

		Global.stage.player_child_body:
			height_offset = 11.2

	stage.spotlight.global_position = who.global_position + Vector3.UP * height_offset

	if switch_on:
		await stage.spotlight.turn_on_spotlight(duration).timeout
	else:
		await stage.spotlight.turn_off_spotlight(duration).timeout


func disable_options_menu() -> void:
	options_amp.has_input_enabled = false


func enable_options_menu() -> void:
	options_amp.has_input_enabled = true


func reset_to_title() -> void:
	are_lights_dimmed = false
	is_paused_whilst_lights_dimmed = false
	was_input_disabled_before_pause = false
	was_input_disabled_before_pause = false
	last_person_on_spotlight = null
	who_is_on_spotlight = null
	lock_dialogue_input = false
	get_tree().change_scene_to_file("res://scenes/stage/stage.tscn")
