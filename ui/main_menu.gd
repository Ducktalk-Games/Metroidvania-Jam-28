extends Node3D

@onready var curtain_animation_player: AnimationPlayer = %CurtainAnimationPlayer
@onready var curtains_left_debug: MeshInstance3D = %CurtainsLeftDebug
@onready var curtains_right_debug: MeshInstance3D = %CurtainsRightDebug
@onready var main_ui: CanvasLayer = %MainUI
@onready var play_button: ActionButton = %PlayButton

signal options_clicked
signal credits_clicked
signal curtains_opened


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.grab_focus()
	curtains_left_debug.hide()
	curtains_right_debug.hide()


func _on_play_button_pressed() -> void:
	Global.current_menu_state = Global.MenuState.GAME
	curtain_animation_player.play("curtain_open")
	main_ui.hide()


func _on_options_button_pressed() -> void:
	Global.current_menu_state = Global.MenuState.OPTIONS
	main_ui.hide()
	options_clicked.emit()


func _on_credits_button_pressed() -> void:
	Global.current_menu_state = Global.MenuState.CREDITS
	main_ui.hide()
	credits_clicked.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func show_ui() -> void:
	main_ui.show()
	play_button.grab_focus()


func _on_curtain_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "curtain_open":
		curtains_opened.emit()
