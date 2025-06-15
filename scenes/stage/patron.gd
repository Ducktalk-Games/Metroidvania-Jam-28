class_name Patron
extends Node3D

@export var music: AudioStreamPlayer
@export var patron_anim_player: PatronAnimationTree


func _ready() -> void:
	set_music_to("main_menu")


func set_music_to(song: StringName) -> void:
	if music["parameters/switch_to_clip"] == song: return

	if song:
		music.set("parameters/switch_to_clip", song)
		patron_anim_player.patron_plays_piano()
	elif song == "" or song == "silence":
		music.set("parameters/switch_to_clip", "silence")
		patron_anim_player.patron_stops_playing_piano()

	if not music.playing:
		music.play()
		await music.finished
