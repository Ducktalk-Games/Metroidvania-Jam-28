extends PlatformLevel

@export var PlayerStart: Marker3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	var character: StageCharacter = Global.stage.stage_body
	global_position = character.character_mesh.global_position
	character.character_mesh.global_position = PlayerStart.global_position
	(Component.find(character, "CanMove") as CanMove).speed *= 0.7
	(Component.find(character, "CanJump") as CanJump).disable()

	await DialogueManager.dialogue_ended
	Global.stage.patron.set_music_to("house_theme")
