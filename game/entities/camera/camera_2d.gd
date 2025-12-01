extends Camera2D
class_name MVMCamera2D

@onready var cam_shake_timer: Timer = $CamShakeTimer

@export var default_target: Node2D
@export var camera_min_speed: float = 5.0
@export var max_distance: float = 10.0
@export var max_time_to_destination: float = 1.0

var target: Node2D
var tween: Tween
var moving_to_target := false

var _t: float = 0.0

var shaking_intensity := 0.0

func _ready() -> void:
	reset_target()
	EventHub.request_camera_follow.connect(set_target)
	EventHub.reset_look.connect(reset_target)

func _physics_process(delta: float) -> void:
	_t += (delta * 75)
	var shake_factor = sin(_t) * shaking_intensity
	offset = Vector2(randf_range(min(0, shake_factor), max(0, shake_factor)), randf_range(min(0, shake_factor), max(0, shake_factor)))
	
	if not moving_to_target:
		return
	
	global_position = global_position.move_toward(target.global_position, 5.0)
	if global_position.distance_squared_to(target.global_position) < 2.0:
		moving_to_target = false
		if target == default_target:
			top_level = false
			position = Vector2.ZERO

func on_room_loaded():
	reset_target()
	global_position = target.global_position
	reset_smoothing()

func reset_target():
	var old_global = global_position
	top_level = true
	global_position = old_global
	target = default_target
	moving_to_target = true

func set_target(node: Node2D):
	var old_global = global_position
	top_level = true
	global_position = old_global
	target = node
	moving_to_target = true

func move_instantly():
	global_position = target.global_position

func shake(time: float, intensity: float = 2.0):
	shaking_intensity = intensity
	cam_shake_timer.stop()
	cam_shake_timer.wait_time = time
	cam_shake_timer.start()


func _on_cam_shake_timer_timeout() -> void:
	shaking_intensity = 0.0
