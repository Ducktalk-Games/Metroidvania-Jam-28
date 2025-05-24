extends Camera3D

@onready var camera_animation_player: AnimationPlayer = %CameraAnimationPlayer


func pivot_to_options() -> void:
	camera_animation_player.play("pivot_to_options")


func pivot_from_options() -> void:
	camera_animation_player.play_backwards("pivot_to_options")


# TODO implement these
func pivot_to_credits() -> void:
	print("pivoting to credits")


func pivot_from_credits() -> void:
	print("pivoting from credits")
