class_name CanReceiveInput
extends Component

signal move_left_right_pressed(left_right: float)
signal jump_pressed(just_pressed: bool)
signal attack(just_pressed: bool)

var movement_component: CanMove


func _node_ready() -> void:
	movement_component = other("CanMove")


func _input(_event: InputEvent) -> void:
	move_left_right_pressed.emit(Input.get_axis("move_left", "move_right"))
	jump_pressed.emit(Input.is_action_just_pressed("jump"))
	attack.emit(Input.is_action_just_pressed("attack"))


func reset_input() -> void:
	move_left_right_pressed.emit(0.0)
	jump_pressed.emit(false)
	attack.emit(false)


func disable() -> void:
	reset_input()
	if movement_component:
		movement_component.disable()

	super.disable()


func enable() -> void:
	if movement_component:
		movement_component.enable()

	reset_input()

	super.enable()
