extends Node2D


@onready var ray_cast_2d: RayCast2D = %RayCast2D
@onready var player_detector: Area2D = %PlayerDetector
@onready var charge_visual: Sprite2D = %ChargeVisual

@onready var timer: Timer = $Timer

@export var bullet_scene: PackedScene
@export var bullet_speed: float = 60.0
@export var bullet_phase_through_walls: bool = false
@export var charge_time := 1.25

var player_reference

var projectile_time := INF

var charging := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = charge_time
	player_detector.body_entered.connect(_on_body_entered)
	player_detector.body_exited.connect(_on_body_exited)
	timer.timeout.connect(attempt_projectile_spawn)


func _physics_process(_delta: float):
	ray_cast_2d.global_rotation = 0
	
	if timer.is_stopped(): # Not charging
		if player_in_sight():
			timer.start()
	else:  # Currently charging
		if not player_in_sight():
			timer.stop()
	
	charge_visual.visible = not timer.is_stopped()
	var progress = (timer.wait_time - timer.time_left) / timer.wait_time
	charge_visual.scale = Vector2.ONE * progress


func attempt_projectile_spawn():
	if not player_in_sight():
		# TODO Cancel fire
		pass
	else:
		spawn_projectile()


func spawn_projectile():
	var projectile = bullet_scene.instantiate()
	projectile.owner_type = HitBox.ENEMY_OWNER
	projectile.velocity = ray_cast_2d.target_position.normalized() * bullet_speed
	projectile.phase_through_walls = bullet_phase_through_walls
	Game.singleton.add_child(projectile)
	projectile.global_position = global_position


func player_in_sight() -> bool:
	if not player_reference:
		return false
	
	ray_cast_2d.target_position = player_reference.global_position - global_position
	ray_cast_2d.force_raycast_update()
	if not ray_cast_2d.is_colliding():
		return false
	
	var collision_object = ray_cast_2d.get_collider()
	if not collision_object == player_reference:
		return false
	
	return true

func _on_body_entered(body: Node2D):
	if not body is MvmPlayer:
		return
	player_reference = body

func _on_body_exited(body: Node2D):
	if not body is MvmPlayer:
		return
	player_reference = null
