class_name CanReset
extends Component

@export var animation_player: AnimationPlayer
var parent: FallingPlatform


func _node_ready() -> void:
	parent = get_object() as FallingPlatform


func reset() -> void:
	animation_player.play("RESET")
	parent.reset_platform()
