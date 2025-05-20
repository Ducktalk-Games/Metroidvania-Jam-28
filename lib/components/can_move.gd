class_name CanMove
extends Component

@onready var character := get_object() as CharacterBody3D

@export
var speed: float = 1.0

var character_direction: float


func _node_ready() -> void:
	var can_receive_input := other("CanReceiveInput") as CanReceiveInput

	if can_receive_input:
		can_receive_input.move_left_right_pressed.connect(_on_can_receive_input_move_left_right_pressed)
	else:
		printerr("CanReceiveInput not found in " + name)


func move(delta: float) -> void:
	character.velocity.x = character_direction * speed

	# Make the character fall
	character.velocity.y += character.get_gravity().y * delta
	# Move the character by its velocity
	character.move_and_slide()


func _physics_process(delta: float) -> void:
	move(delta)


func _on_can_receive_input_move_left_right_pressed(left_right: float) -> void:
	character_direction = left_right
