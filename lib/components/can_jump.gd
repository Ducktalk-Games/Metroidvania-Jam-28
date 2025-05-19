class_name CanJump
extends Component

@export var jump_max: float = 6.0

var can_receive_input: CanReceiveInput

var jump_pressed: bool

@onready var character := get_object() as CharacterBody3D


func _node_ready() -> void:
	can_receive_input = other("CanReceiveInput")

	if can_receive_input:
		can_receive_input.jump_pressed.connect(_on_can_receive_input_jump_pressed)
	else:
		printerr("CanReceiveInput not found in " + name)


func _physics_process(delta: float) -> void:
	if character.is_on_floor():
		if jump_pressed:
			character.velocity.y = jump_max
			jump_pressed = false
		else:
			character.velocity.y = 0.0


func _on_can_receive_input_jump_pressed(just_pressed: bool) -> void:
	jump_pressed = just_pressed
