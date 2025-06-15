class_name HasHealth
extends Component

@export
var health: float = 100.0

@onready
var starting_health: float

@export
var can_be_launched: bool = false

var launch_cooldown: Timer
var waiting: bool = false

@export
var body: Node

@export
var magnitude := 3

var launch_direction: Vector3


func _physics_process(delta: float) -> void:
	if can_be_launched and not waiting and not launch_direction.is_zero_approx():
		if body is Character:
			(other("CanMove") as CanMove).launched = true
			body.velocity = launch_direction
			waiting = true
			launch_cooldown.start()


func _ready() -> void:
	launch_cooldown = Timer.new()
	add_child(launch_cooldown)
	launch_cooldown.wait_time = 3
	launch_cooldown.autostart = false
	launch_cooldown.one_shot = true
	launch_cooldown.timeout.connect(_cooldown_timeout)
	starting_health = health


func _cooldown_timeout() -> void:
	waiting = false
	launch_direction = Vector3()


func reset_health() -> void:
	health = starting_health


func take_damage(value: float, source: Vector3) -> void:
	health -= value

	if health <= 0:
		(other("CanDie") as CanDie).die()

	if can_be_launched and not waiting:
		var direction: float = sign((body.global_position - source).x)
		launch_direction = Vector3(direction*magnitude, magnitude,0)
