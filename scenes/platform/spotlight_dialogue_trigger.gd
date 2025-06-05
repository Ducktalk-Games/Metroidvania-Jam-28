@tool
class_name SpotlightTrigger
extends SimpleDialogueTrigger

@onready var spotlight: SpotLight3D = %Spotlight
@onready var spotlight_mesh: MeshInstance3D = %SpotlightMesh

@export var spotlight_alpha: float = 0.15:
	set(value):
		spotlight_alpha = value
		turn_on_spotlight(1.0)
@export var spotlight_energy: float = 10.0:
	set(value):
		spotlight_energy = value
		turn_on_spotlight(1.0)


func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint(): return
	turn_on_spotlight(0.0)


func _stage_body_entered(body: StageCharacter) -> void:
	super._stage_body_entered(body)
	if not triggered:
		get_tree().create_tween().tween_method(turn_on_spotlight, 0.0, 1.0, 0.2)


func turn_on_spotlight(alpha: float) -> void:
	if not spotlight or not spotlight_mesh: return
	spotlight.light_energy = alpha * spotlight_energy
	(spotlight_mesh.get_active_material(0) as StandardMaterial3D).albedo_color.a = alpha * spotlight_alpha
