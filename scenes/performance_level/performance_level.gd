extends PlatformLevel

const OF_MICE_AND_LIONS_OGG: AudioStreamOggVorbis = preload("uid://cdhmvoqac6ua0")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	await Global.curtains_opened
	Global.current_menu_state = Global.MenuState.PERFORMANCE
	var character: StageCharacter = Global.stage.stage_body

	# 120_matron_song_request
	var sequencer: DialogueSequencer = DialogueSequencer.start_dialog("uid://pb73ouwr1sif")

	# play patron slam -0.5 before audio ends
	await DialogueManager.dialogue_ended
	Global.stage.patron.set_music_to("of_mice_and_lions")
	await get_tree().create_timer(OF_MICE_AND_LIONS_OGG.get_length() - 0.2).timeout
	Global.patron_animation_tree.state_machine.travel("SlamLid")
	await get_tree().create_timer(1.0).timeout
	Global.stage.stage_body.curtain_anim_player.play("flicker_lights")
