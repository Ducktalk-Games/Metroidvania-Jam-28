class_name EnemyPatrol

extends Component

@export
var patrol_speed: float = 10.0

@export
var end_of_path_delay: float = 0.1

@onready
var points_node: Node3D = $PatrollingPoints

@onready
var patrol_agent := get_object() as CharacterBody3D

@onready
var stage := %Stage

var is_waiting: bool

var current_path: String

@export
var point_a : Node3D

@export
var point_b : Node3D


func _ready() -> void:
	is_waiting = false
	current_path = point_a.name
	pass


func patrol(delta: float) -> void:
	var direction_vector: Vector3
	var can_move: bool = !patrol_agent.is_on_wall()
	var distance: float

	match current_path:
		point_a.name:
			direction_vector = (point_a.global_position - patrol_agent.global_position).normalized()
			distance = patrol_agent.global_position.x - point_a.global_position.x

			#Set the direction vector to 0 and switch direction if we are close to the edge of point a
			if distance < 1 || !can_move:
				wait(end_of_path_delay)
				current_path = point_b.name

		point_b.name:
			direction_vector = (point_b.global_position - patrol_agent.global_position).normalized()
			distance = patrol_agent.global_position.x - point_b.global_position.x

			if distance < 1 || !can_move:
				#TODO:
				wait(end_of_path_delay)
				current_path = point_a.name

	#character.velocity.y += character.get_gravity().y * delta
	# Move the character by its velocity
	if !is_waiting:
		#Start movement
		patrol_agent.velocity.x = direction_vector.x * patrol_speed
		patrol_agent.move_and_slide()


func wait(seconds: float) -> void:
	is_waiting = true
	await get_tree().create_timer(end_of_path_delay, true, false).timeout
	is_waiting = false
	pass


func _physics_process(delta: float) -> void:
	if (stage.current_body.name == "StageBody"):
		patrol(delta)

	pass


func _on_reach_patrol_point() -> void:
	is_waiting = true
	#patrol_speed = Vector3.ZERO
	#move_and_slide()
	#await get_tree().create_timer(wait_time).timeout
	#current_target_idx = (current_target_idx + 1) % patrol_points.size()
	#_set_new_path()
	is_waiting = false


func _set_new_path() -> void:
	pass
	#var start = global_position
	#var end = patrol_points[current_target_idx]
	#path = nav.map_get_path(nav_map, start, end, false)
	#path_index = 0
