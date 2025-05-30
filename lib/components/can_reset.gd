class_name CanReset
extends Component

@export var animation_player: AnimationPlayer


func reset() -> void:
	animation_player.play("RESET")
