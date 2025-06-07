@tool
extends BoxTrigger

var player_gets_to_city := false
var player_leaves_city := false


func _stage_body_entered(body: StageCharacter) -> void:
	var inventory: Array[Global.Ability] = (Component.find(body, "CanLoot") as CanLoot).inventory

	if not (Global.Ability.SCISSORS in inventory):
		if not player_gets_to_city:
			player_gets_to_city = true
			# 040_player_gets_to_city
			DialogueSequencer.start_dialog("uid://bj1y8tyg7hsy6")
	elif not player_leaves_city:
		player_leaves_city = true
		# 060_player_leaves_city
		DialogueSequencer.start_dialog("uid://dihna32b60oqa")
