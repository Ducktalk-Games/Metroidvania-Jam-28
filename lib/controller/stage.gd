class_name Stage
extends Node3D

@export
var current_body: Character

@export
var debug_label: Label

@onready
var stage_body: Character = %StageBody

@onready
var player_child_body: Character = %PlayerChildBody


func _ready() -> void:
	update_controllers()
	Global.stage = self


# Enable and disable the stage and player components according to the current body
func update_controllers() -> void:
	var sb_can_move := Component.find(stage_body, "CanMove") as CanMove
	var cb_can_move := Component.find(player_child_body, "CanMove") as CanMove

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


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch"):
		switch_current_body()


func switch_current_body() -> void:
	match current_body:
		stage_body:
			current_body = player_child_body

		player_child_body:
			current_body = stage_body

	update_controllers()


# Logs debug information about the controller on the screen
func debug_log() -> void:
	if debug_label:
		debug_label.text = "Mode: " + current_body.name
