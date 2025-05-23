extends Node3D

@export var speed: float = 5.0
var current_button: Area3D = null


func _on_button_hovered(button: Area3D) -> void:
	current_button = button


func _process(delta: float) -> void:
	if current_button:
		var parent: Node3D = get_parent_node_3d()
		position.y = lerpf(position.y, parent.to_local(current_button.global_position).y, delta * speed)
