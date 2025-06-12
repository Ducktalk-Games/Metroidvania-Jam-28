class_name Character
extends CharacterBody3D

@export var character_mesh: Node3D
@export var map_body: CollisionShape3D

var relocating: bool = false
var reloc_target: Vector3
var reloc_start: Vector3

var nearby_interactable: Interactable
var nearby_item: ItemPickup

signal relocating_complete

@onready
var move_comp: CanMove = Component.find(self, "CanMove")


func relocate(target: Vector3) -> void:
	relocating = true
	reloc_target = target
	reloc_start = global_position

	if move_comp:
		move_comp.disable()

var t := 0.0
var total_time := 1.0


func _process(delta: float) -> void:
	if relocating:
		t += delta / total_time
		global_position = lerp(reloc_start,(reloc_target), t)

		if t >= 1:
			relocating = false
			relocating_complete.emit()
			if move_comp:
				move_comp.enable()
	else:
		t = delta


func rotate_to_audience() -> MethodTweener:
	var player_og_quat: Quaternion = character_mesh.global_basis.get_rotation_quaternion()
	var tween_method: MethodTweener = get_tree().create_tween().tween_method(
			func(delta: float) -> void:
				var b := Basis(player_og_quat.slerp(Quaternion(Vector3.UP, TAU), delta))
				character_mesh.global_basis = b, 0.0, 1.0, 0.2)
	await tween_method.finished
	return tween_method
		
