class_name AbilityPanel
extends Node3D

@export
var stage: Stage

@onready
var animation_player: AnimationPlayer = $AnimationPlayer

var is_pulley_down: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func pulley_down() -> void:
	is_pulley_down = true
	animation_player.play("pulley_down")
	await animation_player.animation_finished


func pulley_up() -> void:
	animation_player.play("pulley_up")
	await animation_player.animation_finished
	is_pulley_down = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
