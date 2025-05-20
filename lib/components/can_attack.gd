class_name CanAttack
extends Component

@export
var value: float = 10.0

@export
var delay_seconds: float = 1

var can_attack: bool = true
@export
var continuous: bool = true

@export
var hit_area: Area3D

# When the attack is actually attempted
signal attack

var cooldown: Timer

var controlled := false


func _ready() -> void:
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.wait_time = delay_seconds
	cooldown.autostart = false
	cooldown.one_shot = not continuous
	cooldown.timeout.connect(_cooldown_timeout)

	# If controllable (player)
	var can_receive_input := other("CanReceiveInput") as CanReceiveInput

	if can_receive_input:
		can_receive_input.attack.connect(_player_attack)
		controlled = true
	else:
		# TODO: Setup area detection
		pass


func _process(delta: float) -> void:
	if not controlled:
		_npc_attack()


func _cooldown_timeout() -> void:
	can_attack = true


func _npc_attack() -> void:
	if not can_attack:
		return

	var targs: Array[Node3D] = hit_area.get_overlapping_bodies().filter(func(t: Node3D)-> bool: return not [get_object(), %StaticFloor, %StageBody].has(t))

	if len(targs) < 1:
		return

	_attack()


func _player_attack(pressed:bool) -> void:
	if not pressed or not can_attack:
		return

	_attack()


func _attack() -> void:
	print("Attempting attack")
	attack.emit()
	damage()
	# reset cooldown
	can_attack = false
	cooldown.start()


func damage() -> void:
	# All bodies in hitbox, but filter out self, stage, and floor
	# Should instead do this using collision layers or similar
	var targs: Array[Node3D] = hit_area.get_overlapping_bodies().filter(func(t: Node3D)-> bool: return not [get_object(), %StaticFloor, %StageBody].has(t))

	for target in targs:
		var targ: HasHealth = Component.find(target, "HasHealth")

		if targ:
			targ.take_damage(value)
		else:
			print("Could not damage target", target.name,"; it has no health component.")
