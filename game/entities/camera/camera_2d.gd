extends Camera2D
class_name MVMCamera2D

@export var default_target: Node2D
@export var camera_min_speed: float = 5.0
@export var max_distance: float = 10.0
@export var max_time_to_destination: float = 1.0

var target: Node2D
const UP := "up"
const DOWN := "down"
const LEFT := "left"
const RIGHT := "right"

var tween: Tween

const H_OFFSET = 80.0
const V_OFFSET = 80.0

const LOOK_UP = Vector2(0.0,-V_OFFSET)
const LOOK_DOWN = Vector2(0.0, V_OFFSET)
const LOOK_LEFT = Vector2(-H_OFFSET, 0.0)
const LOOK_RIGHT = Vector2(H_OFFSET, 0.0)

const TWEEN_TIME = 1.0

var moving_to_target := false

func _ready() -> void:
	reset_target()
	EventHub.request_camera_follow.connect(set_target)
	EventHub.reset_look.connect(reset_target)

func _physics_process(_delta: float) -> void:
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
