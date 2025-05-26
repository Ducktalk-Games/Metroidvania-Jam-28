class_name FiniteStateMachine

extends Component
const E = preload("res://lib/shared/enums.gd")

@export
var current_state: E.FSMState = E.FSMState.PATROLLING

var patrol_component: EnemyPatrol

signal state_changed(new_state: E.FSMState)


func _ready() -> void:
	#patrol_component = Component.find(component_owner(self), "EnemyPatrol")
	#patrol_component.reached_patrol_endpoint.connect(_on_enemy_patrol_reached_patrol_endpoint)
	emit_signal("state_changed", E.FSMState.PATROLLING)


func change_state(new_state: E.FSMState) -> void:
	if current_state != new_state:
		current_state = new_state
		emit_signal("state_changed", new_state)


#func _on_enemy_patrol_reached_patrol_endpoint(new_target: String) -> void:
		#change_state(E.FSMState.WAITING)
