class_name HasHealth
extends Component

@export
var health: float = 100.0


func take_damage(value: float) -> void:
	# TODO: handle player dying
	health -= value
	print("Took ", value, " points of damage.")
	if health <= 0:
		print(get_object().name, " died!")
		get_object().queue_free()
