extends Node3D

var sliderOptions: Array[Slider3D]= []
var focus: Slider3D = null
var is_listening_for_input: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	#Do not run input events if the scene isn't active
	if (!is_listening_for_input): return
	if event.is_action_just_pressed(""):
		pass
