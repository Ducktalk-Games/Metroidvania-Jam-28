class_name Character
extends CharacterBody3D

var can_move: CanMove


func _ready() -> void:
	can_move = Component.find(self, "CanMove")


func _physics_process(delta: float) -> void:
	if can_move.process_mode == PROCESS_MODE_DISABLED:
		return

	# Make the character fall
	velocity.y += get_gravity().y * delta
	# Move the character by its velocity
	move_and_slide()
