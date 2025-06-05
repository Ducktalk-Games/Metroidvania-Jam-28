class_name Stage
extends Node3D

@export
var current_body: Character

@export
var debug_label: Label

@export var kill_dialog := false

@onready
var stage_body: Character = %StageBody

@onready
var player_child_body: Character = %Player

var stage_relocating: bool = false
var player_relocating: bool = false


func _is_relocating() -> bool:
	return stage_relocating or player_relocating


func _ready() -> void:
	update_controllers()
	Global.stage = self
	Global.kill_dialog = kill_dialog


# Enable and disable the stage and player components according to the current body
func update_controllers() -> void:
	var sb_can_move := Component.find(stage_body, "CanMove") as CanMove
	var cb_can_move := Component.find(player_child_body, "CanMove") as CanMove
	print("Enabling ", current_body.name)
	if sb_can_move and cb_can_move:
		match current_body:
			stage_body:
				sb_can_move.enable()
				cb_can_move.disable()

			player_child_body:
				sb_can_move.disable()
				cb_can_move.enable()


func _physics_process(_delta: float) -> void:
	debug_log()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch"):
		switch_current_body()


func relocate_player() -> void:
	var shape_delta: float = player_child_body.map_body.shape.height / 2
	# Move stage to wher the player is
	var player_to_stage_loc := Vector3(
		player_child_body.map_body.global_position.x,
		player_child_body.map_body.global_position.y - shape_delta,
		stage_body.map_body.global_position.z

	)

	stage_body.relocate(player_to_stage_loc) # This offset is due to the player being "closer" than the stage
	stage_relocating = true

	#Move the player back to the center of the stage
	player_child_body.relocate(player_child_body.map_body.global_position - Vector3(0,shape_delta,0))
	player_relocating = true

	while _is_relocating():
		await get_tree().create_timer(0.1).timeout


func switch_current_body() -> void:
	if (current_body.is_on_floor() and !_is_relocating()):
		match current_body:
			stage_body:
				current_body = player_child_body

			player_child_body:
				await relocate_player()
				current_body = stage_body

		update_controllers()


# Logs debug information about the controller on the screen
func debug_log() -> void:
	if debug_label:
		debug_label.text = "Mode: " + current_body.name


func _on_stage_body_relocating_complete() -> void:
	stage_relocating = false


func _on_player_relocating_complete() -> void:
	player_relocating = false
