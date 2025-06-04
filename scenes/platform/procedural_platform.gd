@tool
extends CollisionShape3D
class_name ProceduralPlatform

var mesh_ready: bool = false

var platform_mesh: MeshInstance3D
var string_meshes: Array[MeshInstance3D]

@export_tool_button("Reset Platform", "Callable") var reset_action: Callable = reset_platform
@export_range(2, 10, 1, "or_greater") var string_count: int = 2:
	set(value):
		string_count = value

		if not mesh_ready: return
		create_strings()
@export var string_mesh: Mesh
@export var string_offset: float:
	set(value):
		string_offset = value

		if not mesh_ready: return
		update_all_strings()


func _ready() -> void:
	reset_platform()


func reset_platform() -> void:
	mesh_ready = false

	for child in get_children():
		child.queue_free()

	create_platform()
	create_strings()
	mesh_ready = true


func create_platform() -> void:
	platform_mesh = MeshInstance3D.new()
	platform_mesh.mesh = BoxMesh.new()
	(platform_mesh.mesh as BoxMesh).size = (shape as BoxShape3D).size
	add_child(platform_mesh)


func create_strings() -> void:
	for string in string_meshes:
		string.queue_free()

	string_meshes.clear()
	for row in range(2):
		for column in range(string_count):
			var string := MeshInstance3D.new()
			update_string_positions(string, column, row)
			string.mesh = string_mesh
			add_child(string)
			string_meshes.append(string)


func update_string_positions(string: MeshInstance3D, column: int, row: int) -> void:
	if not string_mesh: return
	string.position.y = string_mesh.get_aabb().size.y / 2.0
	var mesh_aabb: AABB = platform_mesh.mesh.get_aabb()
	string.position.x = string_offset + mesh_aabb.position.x + column * (mesh_aabb.size.x - string_offset * 2)/(string_count - 1)
	string.position.z = string_offset + mesh_aabb.position.z + row * (mesh_aabb.size.z - string_offset * 2)


func _process(delta: float) -> void:
	if not platform_mesh: return
	(platform_mesh.mesh as BoxMesh).size = (shape as BoxShape3D).size
	update_all_strings()


func update_all_strings() -> void:
	var i := 0

	for row in range(2):
		for column in range(string_count):
			update_string_positions(string_meshes[i], column, row)
			i += 1
