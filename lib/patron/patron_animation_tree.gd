class_name PatronAnimationTree
extends AnimationTree

@onready var state_machine: AnimationNodeStateMachinePlayback = self["parameters/playback"]

signal woken_up


func _ready() -> void:
	Global.set_patron_animation_tree(self)


func patron_wakes_up() -> void:
	state_machine.travel("WakeUp")
	await woken_up


func patron_plays_piano() -> void:
	state_machine.travel("PlayingPiano")


func patron_stops_playing_piano() -> void:
	state_machine.travel("Idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "WakeUp":
		woken_up.emit()
