class_name EnemyPatrol
extends Component

##TODO: Move to globals
const E = preload("res://lib/shared/enums.gd")

@onready
var point_a: Marker3D = %PointA

@onready
var point_b: Marker3D = %PointB

@export
var patrol_speed: float = 2.0

@export
var end_of_path_delay: float = 0.0

@export
var debug_fsm: bool = false

@onready
var stage := %Stage

@onready
var patrol_agent: Character = get_object()

@onready
var fsm: FiniteStateMachine = other("FiniteStateMachine")

var point_a_position: Vector3
var point_b_position: Vector3

# false = left, true = right
var patrol_direction: bool = false

var timer: float = 0

signal reached_patrol_endpoint(new_target: String)


func _ready() -> void:
	#Obtain all the references
	point_a_position = point_a.global_position
	point_b_position = point_b.global_position

	fsm.connect("state_changed", Callable(self, "_on_state_changed"))
	pass


func _on_state_changed(state: E.FSMState) -> void:

	match state:
		E.FSMState.PATROLLING:
			if (debug_fsm):
				print("patrolling")

		E.FSMState.WAITING:
			if (debug_fsm):
				print("waiting...")

			await wait(end_of_path_delay)
			fsm.call("change_state", E.FSMState.PATROLLING)


func patrol(_delta: float) -> void:
	if (patrol_direction):
		#Handle the direction towards point a
		patrol_to_destination(point_a_position, point_b_position, _delta)
	else:
		#Handle the direction towards the opposite (point b)
		patrol_to_destination(point_b_position, point_a_position, _delta)


func patrol_to_destination(destination: Vector3, source: Vector3, delta: float) -> void:
	#var direction_vector: Vector3 = (destination - patrol_agent.global_position).normalized()
	var distance: float = patrol_agent.global_position.distance_to(destination)

	##Set the direction vector to 0 and switch direction if we are close to the edge of point a
	if timer > 1:
		timer = 0
		on_reach_patrol_point(!patrol_direction)
		fsm.call("change_state", E.FSMState.WAITING)

	## Move the character by its velocity
	if fsm.current_state == E.FSMState.PATROLLING:
		#patrol_agent.velocity.x = direction_vector.x * patrol_speed
		timer += delta * patrol_speed
		patrol_agent.global_position = destination.lerp(source, timer)


func wait(seconds: float) -> void:
	await get_tree().create_timer(end_of_path_delay, true, false).timeout
	pass


func _physics_process(delta: float) -> void:
	#Early exit to prevent null ref error
	if (!stage.current_body.name == "StageBody" || !patrol_agent):
		return

	if (fsm.current_state == E.FSMState.PATROLLING):
		patrol(delta)


func on_reach_patrol_point(new_path: bool) -> void:
	patrol_direction = new_path
	pass
