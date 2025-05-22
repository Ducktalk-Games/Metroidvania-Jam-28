class_name Character
extends CharacterBody3D

@export
var map_body: CollisionShape3D

var relocating: bool = false
var reloc_target: Vector3
var reloc_start: Vector3

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
		#if velocity.is_zero_approx():
			print("done moving")
			relocating = false
			relocating_complete.emit()
			if move_comp:
				move_comp.enable()
	else:
		t = delta
