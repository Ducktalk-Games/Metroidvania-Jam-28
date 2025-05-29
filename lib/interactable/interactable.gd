extends Area3D
class_name Interactable

signal character_entered
signal character_exited

signal interacted

@onready var key_dialog: KeyDialog = %KeyDialog


func _ready() -> void:
	body_entered.connect(key_dialog._on_item_pickup_body_entered)
	body_exited.connect(key_dialog._on_item_pickup_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body is Character:
		body.nearby_interactable = self


func _on_body_exited(body: Node3D) -> void:
	if body is Character:
		body.nearby_interactable = null
