extends Camera3D

@onready var camera_animation_player: AnimationPlayer = %CameraAnimationPlayer

signal pivoted_to_parent_menu


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		match Global.current_menu_state:
			Global.MenuState.CREDITS:
				pivot_from_credits()

			Global.MenuState.OPTIONS:
				pivot_from_options()


func pivot_to_options() -> void:
	Global.current_menu_state = Global.MenuState.OPTIONS
	camera_animation_player.play("pivot_to_options")


func pivot_from_options() -> void:
	Global.current_menu_state = Global.current_parent_menu_state
	camera_animation_player.play("pivot_to_options", -1, -1, true)
	await camera_animation_player.animation_finished
	pivoted_to_parent_menu.emit()


func pivot_to_credits() -> void:
	Global.current_menu_state = Global.MenuState.CREDITS
	camera_animation_player.play("pivot_to_credits")


func pivot_from_credits() -> void:
	Global.current_menu_state = Global.current_parent_menu_state
	camera_animation_player.play("pivot_to_credits", -1, -1, true)
	await camera_animation_player.animation_finished
	pivoted_to_parent_menu.emit()
