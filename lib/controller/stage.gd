class_name Stage
extends Node3D

@export
var speed: float = 0.3

@export
var jump_max: float = 6.0

@export
var current_body: CharacterBody3D

@export
var debug_label: Label

@onready
var stage_body: CharacterBody3D = %StageBody

@onready
var player_child_body: CharacterBody3D = %PlayerChildBody

var input_direction: float
var jump_pressed: bool


func _physics_process(_delta: float) -> void:
	process_active_body()
	debug_log()


func process_active_body() -> void:
	handle_fall()
	handle_jump()
	current_body.velocity.x = input_direction * speed
	current_body.move_and_slide()


func handle_fall() -> void:
	current_body.velocity.y += current_body.get_gravity().y * 0.02


func handle_jump() -> void:
	if current_body.is_on_floor():
		if jump_pressed:
			current_body.velocity.y = jump_max
			jump_pressed = false
		else:
			current_body.velocity.y = 0.0


func _input(event: InputEvent) -> void:
	input_direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("switch"):
		match current_body:
			stage_body:
				current_body = player_child_body

			player_child_body:
				current_body = stage_body

	jump_pressed = Input.is_action_just_pressed("jump")


# Logs debug information about the controller on the screen
func debug_log() -> void:
	if debug_label:
		debug_label.text = "Mode: " + current_body.name
