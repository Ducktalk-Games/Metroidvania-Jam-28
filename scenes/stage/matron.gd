class_name Matron
extends Node3D

@export var animation_tree: AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


func get_angry() -> void:
	state_machine.travel("FreakingOut")
