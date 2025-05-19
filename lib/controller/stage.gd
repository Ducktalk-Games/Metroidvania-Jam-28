class_name Stage
extends Node3D

enum EController {
	KID,
	SCENARIO
}

@export
var current_controller: EController = EController.SCENARIO

@export
var speed: float = 0.3

@export
var debug_label: Label

@onready
var stage_body: CharacterBody3D = %StageBody

@onready
var player_child_body: CharacterBody3D = %PlayerChildBody

var input_direction: float


func _physics_process(delta: float) -> void:
	process_active_body()
	debug_log()


func process_active_body() -> void:
	match current_controller:
		EController.KID:
			player_child_body.velocity.x = input_direction * speed
			player_child_body.move_and_slide()

		EController.SCENARIO:
			stage_body.velocity.x = input_direction * speed
			stage_body.move_and_slide()


func _input(event: InputEvent) -> void:
	input_direction = Input.get_axis("move_left", "move_right")

	if (Input.is_action_just_pressed("switch") && current_controller == EController.SCENARIO):
		current_controller = EController.KID

	elif(Input.is_action_just_pressed("switch") && current_controller == EController.KID):
		current_controller = EController.SCENARIO


# Logs debug information about the controller on the screen
func debug_log() -> void:
	if debug_label:
		debug_label.text = "Mode: %s" % EController.keys()[current_controller]
