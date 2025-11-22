extends Node2D


func _process(delta: float) -> void:
	global_position = get_viewport().get_camera_2d().get_target_position()
