extends Node3D

@onready
var curtain_animation_player: AnimationPlayer = %CurtainAnimationPlayer

@onready
var main_ui: CanvasLayer = %MainUI

@onready
var main_camera: Camera3D = %MainCamera

@onready
var menu_camera: Camera3D = %MenuCamera

signal options_pressed
signal credits_pressed
signal curtains_opened


func _ready() -> void:
	show()


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_cancel"):
		#match Global.current_menu_state:
			#Global.MenuState.CREDITS:
				#pivot_from_credits()
#
			#Global.MenuState.OPTIONS:
				#pivot_from_options()


func _on_play_button_pressed() -> void:
	Global.current_menu_state = Global.MenuState.GAME
	curtain_animation_player.play("curtain_open")
	main_camera.current = true
	menu_camera.current = false
	main_ui.hide()


func _on_options_button_pressed() -> void:
	Global.current_menu_state = Global.MenuState.OPTIONS
	main_ui.hide()
	options_pressed.emit()


func _on_credits_button_pressed() -> void:
	Global.current_menu_state = Global.MenuState.CREDITS
	main_ui.hide()
	credits_pressed.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_curtain_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "curtain_open":
		curtains_opened.emit()
		# 010_intro
		DialogueSequencer.start_dialog("uid://cqs1s27w3ad8t")
