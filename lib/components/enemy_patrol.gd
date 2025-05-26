class_name EnemyPatrol
extends Component

const E = preload("res://lib/shared/enums.gd")

@export
var point_a: Area3D

@export
var point_b: Area3D

@export
var patrol_speed: float = 2.0

@export
var end_of_path_delay: float = 0.0

var patrol_agent: Character

@onready
var stage := %Stage

var collision_raycast:RayCast3D

var fsm: FiniteStateMachine

var current_path: String

signal reached_patrol_endpoint(new_target: String)


func _ready() -> void:
	# Get the component owner node
	var component_owner := get_parent()

	if component_owner == null:
		push_error("Component owner not found.")
		return

	#Obtain all the references
	current_path = point_a.name
	var componentOwner := get_parent()
	fsm = componentOwner.get_node_or_null("FiniteStateMachine") as FiniteStateMachine
	patrol_agent = componentOwner.get_parent() as Character
	collision_raycast = patrol_agent.get_node("RayCast") as RayCast3D
	fsm.connect("state_changed", Callable(self, "_on_state_changed"))
	reached_patrol_endpoint.connect(_on_reach_patrol_point)
	pass


func _on_state_changed(state: E.FSMState) -> void:

	match state:
		E.FSMState.PATROLLING:
			print("patrolling")

		E.FSMState.WAITING:
			print("waiting...")
			await wait(end_of_path_delay)
			fsm.call("change_state", E.FSMState.PATROLLING)


func patrol(_delta: float) -> void:
	match current_path:
		point_a.name:
			#Handle the direction towards point a
			patrol_to_destination(point_a, point_b)

		point_b.name:
			#Handle the direction towards the opposite (point b)
			patrol_to_destination(point_b, point_a)


func patrol_to_destination(destination: Node3D, inverse: Node3D) -> void:
	var direction_vector: Vector3 = (destination.global_position - patrol_agent.global_position).normalized()
	collision_raycast.target_position = direction_vector
	collision_raycast.force_raycast_update()
#
	##Set the direction vector to 0 and switch direction if we are close to the edge of point a
	if collision_raycast.is_colliding() || patrol_agent.is_on_wall():
		emit_signal("reached_patrol_endpoint", inverse.name)
		fsm.call("change_state", E.FSMState.WAITING)

	## Move the character by its velocity
	if fsm.current_state == E.FSMState.PATROLLING:
		patrol_agent.velocity.x = direction_vector.x * patrol_speed
		patrol_agent.move_and_slide()


func wait(seconds: float) -> void:
	await get_tree().create_timer(end_of_path_delay, true, false).timeout
	pass


func _physics_process(delta: float) -> void:
	#Early exit to prevent null ref error
	if (!stage.current_body.name == "StageBody" || !patrol_agent):
		return

	if (fsm.current_state == E.FSMState.PATROLLING):
		patrol(delta)


func _on_reach_patrol_point(new_path: String) -> void:
	current_path = new_path
	print("on reach patrol point" + current_path)
	pass
