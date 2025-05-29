extends Node3D
class_name Selector

@export var speed: float = 5.0

@onready var button_array: Array[PauseMenuButton] = [%ResumeButton,%OptionsButton,%ExitButton]
var current_button: PauseMenuButton

var is_paused: bool = false


func _on_button_hovered(button: PauseMenuButton) -> void:
	current_button = button


func _input(_event: InputEvent) -> void:
	if is_paused:
		if Input.is_action_just_pressed("ui_down"):
			current_button = button_array[(button_array.find(current_button) + 1) % 3]

		if Input.is_action_just_pressed("ui_up"):
			current_button = button_array[(button_array.find(current_button) - 1) % 3]

		if Input.is_action_just_pressed("ui_accept"):
			current_button.button_clicked.emit(current_button)


func _process(delta: float) -> void:
	if current_button:
		var parent: Node3D = get_parent_node_3d()
		position.y = lerpf(position.y, parent.to_local(current_button.global_position).y, delta * speed)
