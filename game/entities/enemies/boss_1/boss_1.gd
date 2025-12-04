extends Node2D

const INACTIVE_MODULATE = Color("#525252")

@onready var health_bar: ProgressBar = %HealthBar
@onready var projectile_spawner: Marker2D = %ProjectileSpawner
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_position: Marker2D = %PlayerPosition
@onready var floor_ray_cast: RayCast2D = %FloorRayCast
@onready var floor_position: Marker2D = %FloorPosition
@onready var health_component: HealthComponent = %HealthComponent
@onready var laser: Node2D = %Laser
@onready var hand_l: Node2D = %HandL
@onready var hand_r: Node2D = %HandR

const buffer_size := 15

signal target_reached
signal killed

var active := false:
	set(val):
		var was_active = active
		active = val
		if not was_active and active:
			start_fight()

var target: Vector2
var probability_list := []
var probability_list_max_size: int
var movement_speed := 5.0

var can_move := false
var target_buffer : Array[Vector2] = []

@export var following := true
@export var floor_animations: Array[String] = []
@export var combat_animations: Array[String] = []
@export var phase_change_health := 5

@export var projectile_scene: PackedScene
@export var room_center: Node2D

var phase = 1

func _process(_delta: float) -> void:
	var hand_l_color = Color.WHITE
	if not hand_l.get_node("HitBox").monitoring and not hand_l.get_node("HurtBox").monitorable:
		hand_l_color = INACTIVE_MODULATE
	var hand_r_color = Color.WHITE
	if not hand_r.get_node("HitBox").monitoring and not hand_r.get_node("HurtBox").monitorable:
		hand_r_color = INACTIVE_MODULATE
	hand_l.modulate = hand_l_color
	hand_r.modulate = hand_r_color


func _ready() -> void:
	health_bar.hide()
	deactivate_hand("L")
	deactivate_hand("R")
	reset_probability_list()
	health_component.hp_changed.connect(_on_health_component_hp_changed.bind(health_component))
	animation_player.animation_finished.connect(_on_animation_ended)


func _physics_process(_delta: float) -> void:
	# Target buffer/follow delay
	target_buffer.append(MetSys.exact_player_position - relative_player_position())
	while target_buffer.size() > buffer_size:
		target_buffer.pop_front()
	
	if target_buffer.size() == buffer_size:
		target = target_buffer[0]
		can_move = true
	else:
		can_move = false
	
	
	if not active:
		return
	
	if following and can_move:
		if animation_player.current_animation in floor_animations and floor_ray_cast.is_colliding():
			target.y = floor_ray_cast.get_collision_point().y - floor_position.position.y
		var mov = movement_speed / 2 if laser.active else movement_speed
		global_position = global_position.move_toward(target, mov)
		if global_position.distance_to(target) <= 3.0:
			target_reached.emit()


func kill():
	killed.emit()
	queue_free()


func next_move():
	deactivate_hand("L")
	deactivate_hand("R")
	await target_reached
	var _next_move = get_next_move()
	animation_player.play(_next_move)


func get_next_move():
	if probability_list.size() <= probability_list_max_size/2:
		reset_probability_list()
	var _next_move = probability_list.pick_random()
	probability_list.remove_at(probability_list.find(_next_move))
	return _next_move


func reset_probability_list():
	probability_list = []
	for i in range(3):
		probability_list += combat_animations

func activate_hand(side: String):
	var hand = {
		"L": hand_l,
		"R": hand_r
	}[side.to_upper()]
	var hitbox = hand.get_node("HitBox")
	hitbox.monitoring = true

func deactivate_hand(side: String):
	var hand = {
		"L": hand_l,
		"R": hand_r
	}[side.to_upper()]
	var hitbox = hand.get_node("HitBox")
	hitbox.monitoring = false

func activate_l_hand():
	activate_hand("L")

func activate_r_hand():
	activate_hand("R")

func deactivate_l_hand():
	deactivate_hand("L")

func deactivate_r_hand():
	deactivate_hand("R")

func relative_player_position():
	return player_position.global_position - global_position

func _on_hurt(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, stun_time: float, origin: Node) -> void:
	health_component.hp -= damage


func _on_health_component_hp_changed(health_component: HealthComponent) -> void:
	health_bar.value = health_component.hp
	if health_component.hp <= phase_change_health:
		phase = 2

	if health_component.hp == 0:
		kill()

func impact():
	Game.singleton.camera.shake(0.2)
	%ImpactAudio.play()
	if phase >= 2:
		spawn_radial_projectiles(2)

func spawn_radial_projectiles(projectile_count: float):
	var bullet_speed = 100.0
	var angle_step = 360.0 / projectile_count
	for i in range(projectile_count):
		var bullet_instance = projectile_scene.instantiate() as Bullet
		
		bullet_instance.velocity = Vector2.RIGHT.rotated(deg_to_rad(angle_step*i)) * bullet_speed
		bullet_instance.phase_through_walls = true
		bullet_instance.owner_type = HitBox.ENEMY_OWNER
		
		Game.singleton.gameplay.add_child(bullet_instance)
		
		bullet_instance.global_position = projectile_spawner.global_position

func start_fight():
	await play_intro()
	print("intro done")
	next_move()
	init_progress_bar()

func init_progress_bar():
	health_bar.show()
	var target_size = health_bar.size
	var tween = create_tween()
	health_bar.size = Vector2(0, health_bar.size.y)
	tween.tween_property(health_bar, "size", target_size, 1.0)
	
	health_bar.max_value = health_component.max_hp
	health_bar.value = health_component.hp


func _on_animation_ended(animation: StringName) -> void:
	next_move()


func move_to_center(t: float):
	create_tween().tween_property(self, "global_position", room_center.global_position, t)


func play_intro():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.WHITE, 1.0)
	tween.tween_property(self, "scale", Vector2.ONE, 1.0)
	await tween.finished
