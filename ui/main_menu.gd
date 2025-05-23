extends Node3D

@onready var curtain_animation_player: AnimationPlayer = %CurtainAnimationPlayer
@onready var curtains_left_debug: MeshInstance3D = %CurtainsLeftDebug
@onready var curtains_right_debug: MeshInstance3D = %CurtainsRightDebug
@onready var main_ui: CanvasLayer = %MainUI
@onready var play_button: ActionButton = %PlayButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.grab_focus()
	curtains_left_debug.hide()
	curtains_right_debug.hide()


func _on_play_button_pressed() -> void:
	curtain_animation_player.play("curtain_open")
	main_ui.hide()


func _on_options_button_pressed() -> void:
	print("OPTIONS")


func _on_credits_button_pressed() -> void:
	print("CREDITS")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
