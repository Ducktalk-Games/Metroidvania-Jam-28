class_name CanDie
extends Component

#How much do we have to go below the Y axis before the character is considered for respawn
@export var fall_death_offset: float = -25.0
@export var can_respawn: CanRespawn

var character: Character

signal has_died


func _node_ready() -> void:
	character = get_object()


func _physics_process(delta: float) -> void:
	if character.global_position.y <= fall_death_offset \
		and(can_respawn and not can_respawn.resetting):
			die()


func die() -> void:
	# TODO: handle character death in a special way
	if character.is_player:
		pass
	has_died.emit()
