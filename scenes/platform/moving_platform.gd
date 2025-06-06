@tool
extends Path3D

@onready var moving_platform_path_follow: PathFollow3D = $MovingPlatformPathFollow

@export_range(0.0, 1.0) var path_ratio: float = 0.0:
	set(value):
		moving_platform_path_follow.progress_ratio = value
		path_ratio = value

@export var path_duration: float = 5.0
@export var wait_duration: float = 0.1


func _ready() -> void:
	if Engine.is_editor_hint(): return
	path_ratio = 0.0
	var tween: Tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "path_ratio", 1.0, path_duration)
	tween.tween_interval(wait_duration)
	tween.tween_property(self, "path_ratio", 0.0, path_duration)
	tween.tween_interval(wait_duration)
