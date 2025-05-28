extends RigidBody3D

@onready var platform_animation: AnimationPlayer = %PlatformAnimation


func _on_hit_detection_body_entered(body: Node3D) -> void:
	if body is Character:
		platform_animation.play("fall")
