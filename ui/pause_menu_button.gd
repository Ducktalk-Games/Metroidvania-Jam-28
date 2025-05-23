extends Area3D

signal button_hovered(button: Area3D)
signal button_clicked(button: Area3D)


func _ready() -> void:
	mouse_entered.connect(func() -> void: button_hovered.emit(self))
	input_event.connect(_on_input_event)


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_pressed("button_select"):
		button_clicked.emit(self)
