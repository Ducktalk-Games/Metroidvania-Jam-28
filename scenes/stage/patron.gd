class_name Patron
extends Node3D

@export var music: AudioStreamPlayer


func set_music_to(song: StringName) -> void:
	if music["parameters/switch_to_clip"] == song: return

	if song:
		music.set("parameters/switch_to_clip", song)
	else:
		music.set("parameters/switch_to_clip", "silence")

	if not music.playing:
		music.play()
