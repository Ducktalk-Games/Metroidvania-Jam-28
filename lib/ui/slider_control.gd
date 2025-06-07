class_name SliderControl
extends Component

@export
var current_slider_offset: int = 0.0

@export
var default_offset: int = 1.0

@onready
var start_point: Marker3D = %Start

@onready
var end_point: Marker3D = %End

@onready
var knob: MeshInstance3D = %Knob


signal has_changed_value


func _ready() -> void:
	current_slider_offset = default_offset
	interpolate_to(start_point)


# Moves the knob to a point without tweening
func interpolate_to(to: Marker3D) -> void:
	knob.position.x = to.position.x
	knob.position.y = to.position.y
	update_slider_value()
	pass


# Normalises the distance value of the knob with the start and end points
# into a 0-1 float value
func update_slider_value() -> void:
	var a: Vector3 = start_point.position
	var b: Vector3 = end_point.position
	var p: Vector3 = knob.position

	var ab: Vector3 = b - a
	var ap: Vector3 = p - a

	var length: float = ab.length_squared()

	var t: float = 0

	if (length == 0):
		t = 0
	else:
		t = ap.dot(ab) / length

	current_slider_offset = clamp(t, 0, 1)
	has_changed_value.emit(current_slider_offset)


# Moves the knob to a point by tweening TODO:
func tween_to(to: Marker3D, delta: float) -> void:
	knob.position.x = to.position.x
	knob.position.y = to.position.y
	pass
