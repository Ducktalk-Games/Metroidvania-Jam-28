class_name CanMove
extends Component

@onready var character := get_object() as Character

@export var speed: float = 1.0

@export var animation_tree: AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

var character_direction: float
var rotation_offset := 0.01
var rotation_snapped: bool = true

var launched: bool = false


func _node_ready() -> void:

	var can_receive_input := other("CanReceiveInput") as CanReceiveInput

	if can_receive_input:
		can_receive_input.move_left_right_pressed.connect(_on_can_receive_input_move_left_right_pressed)
	else:
		printerr("CanReceiveInput not found in " + name)


func move(delta: float) -> void:
	if not launched:
		character.velocity.x = character_direction * speed

	if character.velocity.x != 0.0:
		var target_angle := Vector3.BACK.signed_angle_to(Vector3(character.velocity.x, 0.0, 0.0), Vector3.UP)

		if abs(target_angle - character.character_mesh.global_rotation.y) < 0.1 and not rotation_snapped:
			rotation_snapped = true
			character.character_mesh.global_rotation.y = target_angle
			rotation_offset *= -1
		else:
			rotation_snapped = false
			character.character_mesh.global_rotation.y = lerp_angle(character.character_mesh.global_rotation.y + rotation_offset, target_angle, delta * 10)

	if animation_tree and state_machine.get_current_node() in ["WalkInPlace", "WalkForward"]:
		animation_tree["parameters/" + state_machine.get_current_node() + "/blend_position"] = abs(character.velocity.x)

	# Make the character fall
	character.velocity.y += character.get_gravity().y * delta
	# Move the character by its velocity
	character.move_and_slide()


func _physics_process(delta: float) -> void:
	move(delta)
	if launched:
		if character.is_on_floor():
			launched = false


func _on_can_receive_input_move_left_right_pressed(left_right: float) -> void:
	character_direction = left_right
