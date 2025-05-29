extends Interactable

@export var animation_player: AnimationPlayer


func _on_interacted() -> void:
	var can_loot: CanLoot = Component.find(Global.stage.stage_body, "CanLoot") as CanLoot

	if Global.Ability.SCISSORS in can_loot.inventory:
		animation_player.play("CutOpen")
	else:
		print("NO SCISSORS DIALOG HERE")
