class_name MainMenu
extends Node3D

@onready
var curtains_left_debug: MeshInstance3D = %CurtainsLeftDebug

@onready
var curtains_right_debug: MeshInstance3D = %CurtainsRightDebug

@onready
var play_button: ActionButton = %PlayButton


func _ready() -> void:
	#This is to ensure that the grab focus event triggers with the animation
	#This is due to an internal bug with the ActionButton component
	var delay_timer: Timer = Timer.new()
	delay_timer.one_shot = true
	delay_timer.wait_time = 0.16
	self.add_child(delay_timer)
	delay_timer.connect("timeout", _on_timer_timeout)
	delay_timer.start()
	curtains_left_debug.hide()
	curtains_right_debug.hide()


func _on_timer_timeout() -> void:
	play_button.call_deferred("grab_focus")
