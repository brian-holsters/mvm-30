extends Area2D
class_name CameraArea2D

@export var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 0 # Disable layer
	collision_mask = 2 # Set mask to layer 2 only (player collider)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body is MvmPlayer:
		EventHub.request_camera_follow.emit(target)

func _on_body_exited(body: Node2D):
	if body is MvmPlayer:
		EventHub.reset_look.emit()
