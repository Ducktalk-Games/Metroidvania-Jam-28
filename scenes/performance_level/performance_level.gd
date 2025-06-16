extends PlatformLevel

const OF_MICE_AND_LIONS_OGG: AudioStreamOggVorbis = preload("uid://cdhmvoqac6ua0")

@export var end_credits_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	Global.current_menu_state = Global.MenuState.PERFORMANCE
	var character: StageCharacter = Global.stage.stage_body
	character.global_position = Vector3.ZERO
	Global.stage.player_child_body.character_mesh.global_position = character.global_position

	# 120_matron_song_request
	DialogueSequencer.start_dialog("uid://pb73ouwr1sif")

	# play patron slam -0.5 before audio ends
	await DialogueManager.dialogue_ended
	Global.stage.patron.set_music_to("of_mice_and_lions")
	Global.stage.player_child_body.move_comp.state_machine.travel("Singing")
	await get_tree().create_timer(OF_MICE_AND_LIONS_OGG.get_length() - 1.0).timeout
	Global.patron_animation_tree.state_machine.travel("SlamLid")
	await get_tree().create_timer(1.0).timeout
	Global.stage.player_child_body.move_comp.state_machine.travel("Idle")
	Global.dim_lights(false)
	Global.stage.stage_body.curtain_anim_player.play("flicker_lights")
	await Global.stage.stage_body.curtain_anim_player.animation_finished
	get_tree().change_scene_to_packed(end_credits_scene)
