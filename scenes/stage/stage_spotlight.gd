@tool
class_name StageSpotlight
extends SpotLight3D

@export var spotlight_mesh: MeshInstance3D

@export var spotlight_alpha: float = 0.15:
	set(value):
		spotlight_alpha = value
		alpha_spotlight(1.0)

@export var spotlight_energy: float = 10.0:
	set(value):
		spotlight_energy = value
		alpha_spotlight(1.0)

var spotlight_cylinder: CylinderMesh


func _ready() -> void:
	create_spotlight_cylinder()
	alpha_spotlight(0.0)


func _process(delta: float) -> void:
	create_spotlight_cylinder()


func create_spotlight_cylinder() -> void:
	if not spotlight_mesh: return
	if not spotlight_cylinder:
		spotlight_cylinder = CylinderMesh.new()

	spotlight_cylinder.height = spot_range
	spotlight_cylinder.top_radius = 0.0
	spotlight_cylinder.bottom_radius = (tan(deg_to_rad(spot_angle)) * spot_range)
	spotlight_mesh.position.z = -spot_range/2.0
	spotlight_mesh.mesh = spotlight_cylinder


func turn_on_spotlight(duration: float = 0.2) -> SceneTreeTimer:
	get_tree().create_tween().tween_method(alpha_spotlight, 0.0, 1.0, duration)
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	return timer


func turn_off_spotlight(duration: float = 0.5) -> SceneTreeTimer:
	get_tree().create_tween().tween_method(alpha_spotlight, 1.0, 0.0, duration)
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	return timer


func alpha_spotlight(alpha: float) -> void:
	if not spotlight_mesh: return
	light_energy = alpha * spotlight_energy
	(spotlight_mesh.get_active_material(0) as StandardMaterial3D).albedo_color.a = alpha * spotlight_alpha
