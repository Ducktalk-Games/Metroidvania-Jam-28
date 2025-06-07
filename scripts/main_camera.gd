extends Camera3D

@onready
var camera_animation_player: AnimationPlayer = %MenuCameraAnimationPlayer

signal pivoted_to_parent_menu


func pivot_to_options() -> void:
	Global.current_menu_state = Global.MenuState.OPTIONS
	camera_animation_player.play("pivot_to_options")


func pivot_from_options() -> void:
	Global.current_menu_state = Global.current_parent_menu_state
	camera_animation_player.play("pivot_to_options", -1, -1, true)
	wait_for_from_anim_to_finish()


func pivot_to_credits() -> void:
	Global.current_menu_state = Global.MenuState.CREDITS
	camera_animation_player.play("pivot_to_credits")


func pivot_from_credits() -> void:
	Global.current_menu_state = Global.current_parent_menu_state
	camera_animation_player.play("pivot_to_credits", -1, -1, true)
	wait_for_from_anim_to_finish()


func wait_for_from_anim_to_finish() -> void:
	await camera_animation_player.animation_finished
	pivoted_to_parent_menu.emit()
