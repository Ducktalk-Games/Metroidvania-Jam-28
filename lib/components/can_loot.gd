extends Component

var character: Character
var inventory: Array[Global.Ability]

@onready var ui: CanvasLayer = %UI
const ITEM_POPUP = preload("res://ui/item_popup.tscn")


func _node_ready() -> void:
	character = get_object() as Character


func _on_can_receive_input_interact_pressed(just_pressed: bool) -> void:
	if just_pressed and character.nearby_item:
		if not character.nearby_item.ability in inventory:
			inventory.append(character.nearby_item.ability)
			Global.spawn_item_popup(character.nearby_item.ability)
			character.nearby_item.queue_free()
