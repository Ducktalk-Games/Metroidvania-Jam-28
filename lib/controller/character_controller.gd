extends Node3D

enum EControllerMode {
	KID,
	SCENARIO
}

@export
var current_controller_mode: EControllerMode = EControllerMode.SCENARIO

@export
var speed: float = 0.3

@export var debug_label: Label

@onready
var child_controller: CharacterBody3D = $Child

@onready
var scenario_controller: CharacterBody3D = $Child/Box


func _process(delta: float) -> void:
	debug_label.text = "Mode: %s" % EControllerMode.keys()[current_controller_mode]


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	process_active_controller()
	debug_log()
	pass


func get_input_direction() -> Vector3:
	var direction := Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if Input.is_action_pressed("move_back"):
		direction.z += 1

	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("move_right"):
		direction.x += 1

	return direction.normalized()


func process_active_controller() -> void:
	switch_controller()
	var direction: Vector3 = get_input_direction()
	process_movement(current_controller_mode, direction)


func process_movement(which: EControllerMode, direction: Vector3) -> void:
	if (current_controller_mode == EControllerMode.KID):
		child_controller.velocity.x = direction.x * speed
		child_controller.velocity.z = direction.z * speed
		child_controller.move_and_slide()

		#Freeze the scenario when the kid is moving
		scenario_controller.velocity = Vector3.ZERO
	else:
		scenario_controller.velocity.x = direction.x * speed
		scenario_controller.velocity.z = direction.z * speed
		scenario_controller.move_and_slide()

		#Freeze the kid when the scenario is moving
		child_controller.velocity = Vector3.ZERO

	pass


func switch_controller() -> void:
	if (Input.is_action_just_pressed("switch") && current_controller_mode == EControllerMode.SCENARIO):
		current_controller_mode = EControllerMode.KID

	elif(Input.is_action_just_pressed("switch") && current_controller_mode == EControllerMode.KID):
		current_controller_mode = EControllerMode.SCENARIO


# Logs debug information about the controller on the screen
func debug_log() -> void:
	if (debug_label):
		debug_label.text = "Mode: %s" % EControllerMode.keys()[current_controller_mode]
