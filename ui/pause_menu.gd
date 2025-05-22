extends Node3D

@onready var animation_tree: AnimationTree = %AnimationTree

var is_paused: bool


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_paused:
			animation_tree["parameters/conditions/roll"] = true
			is_paused = true
		else:
			print("this")
			animation_tree["parameters/conditions/dismiss"] = true
			is_paused = false
