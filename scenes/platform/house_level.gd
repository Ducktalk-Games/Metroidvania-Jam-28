extends PlatformLevel

@export var PlayerStart: Marker3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var character: StageCharacter = Global.stage.stage_body
	character.global_position = PlayerStart.global_position
	(Component.find(character, "CanMove") as CanMove).speed *= 0.5
