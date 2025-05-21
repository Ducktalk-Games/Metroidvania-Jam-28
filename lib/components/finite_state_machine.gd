class_name FiniteStateMachine

extends Component
const E = preload("res://lib/shared/enums.gd")

@export
var current_state: E.FSMState = E.FSMState.PATROLLING

signal state_changed(new_state: E.FSMState)


func _ready() -> void:
	emit_signal("state_changed", E.FSMState.PATROLLING)


func change_state(new_state: E.FSMState) -> void:
	if current_state != new_state:
		current_state =new_state
		emit_signal("state_changed", new_state)

	pass


#func _reached_patrol_endpoint
