extends BoxTrigger


func _stage_body_entered(body: StageCharacter) -> void:
	if not triggered:
		var inventory: Array[Global.Ability] = (Component.find(body, "CanLoot") as CanLoot).inventory

		if Global.Ability.SCISSORS in inventory:
			# 060_player_leaves_city
			DialogueSequencer.start_dialog("uid://dihna32b60oqa")
			triggered = true

	Global.stage.patron.set_music_to("forest_theme")
