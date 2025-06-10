@tool
extends BoxTrigger

var player_gets_to_city := false
var player_leaves_city := false


func _stage_body_entered(body: StageCharacter) -> void:

	if not triggered:
		var inventory: Array[Global.Ability] = (Component.find(body, "CanLoot") as CanLoot).inventory

		if not (Global.Ability.SCISSORS in inventory):
			# 040_player_gets_to_city
			DialogueSequencer.start_dialog("uid://bj1y8tyg7hsy6")
			triggered = true

	Global.stage.patron.set_music_to("city_theme")
