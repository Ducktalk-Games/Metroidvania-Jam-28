class_name HasHealth
extends Component

@export
var health: float = 100.0


func take_damage(value: float) -> void:
	health -= value

	if health <= 0:
		(other("CanDie") as CanDie)
