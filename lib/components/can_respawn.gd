extends Component

var last_respawn: Vector3
@onready
var checkpoints := get_tree().get_nodes_in_group("checkpoints")

@onready
var stageBody: Character = get_object()

#How much do we have to go below the Y axis before the character is considered for respawn
@export
var fall_death_offset: float = -25.0


func _process(delta: float) -> void:
	check_offset_death()
	if (len(checkpoints) == 0):
		print("let's do this")
		checkpoints = get_tree().get_nodes_in_group("checkpoints")
		connect_signals()


#Doing it here since at the start of the game we have the menu scene and the checkpoint number is 0
#This is a dirty workaround, please don't attempt this, Eleonor.
func connect_signals() -> void:
	for point in checkpoints:
		point.set_respawn_point.connect(_on_set_respawn_point)


func _ready() -> void:
	pass


func _on_set_respawn_point(point: Vector3) -> void:
	print("Respawn point updated to:", point)
	last_respawn = point
	pass


func check_offset_death() -> void:
	if (stageBody.global_position.y <= fall_death_offset):
		on_die()


func on_die() -> void:
	print("celeste respawn")
	get_object().global_position = last_respawn
