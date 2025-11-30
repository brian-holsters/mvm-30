extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_position: Marker2D = %PlayerPosition
@onready var floor_ray_cast: RayCast2D = %FloorRayCast
@onready var floor_position: Marker2D = %FloorPosition
@onready var health_component: HealthComponent = %HealthComponent

const buffer_size := 15

signal target_reached
signal killed

var active := false:
	set(val):
		var was_active = active
		active = val
		if not was_active and active:
			next_move()
var target: Vector2
var probability_list := []
var probability_list_max_size: int
var movement_speed := 5.0

@export var following := true
var can_move := false
var target_buffer : Array[Vector2] = []

@export var floor_animations: Array[String] = []
@export var phase_change_health := 5


@export var projectile_scene: PackedScene

var phase = 1

func _ready() -> void:
	deactivate_hand("L")
	deactivate_hand("R")
	reset_probability_list()
	animation_player.animation_finished.connect(next_move.unbind(1))


func _physics_process(_delta: float) -> void:
	# Always following
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
		global_position = global_position.move_toward(target, movement_speed)
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
	var animations = Array(animation_player.get_animation_list())
	probability_list = []
	for i in range(3):
		probability_list += animations


func activate_hand(side: String):
	var hand = get_node("Root/Hand"+side)
	var hitbox = hand.get_node("HitBox")
	var hurtbox = hand.get_node("HurtBox")
	hand.modulate = Color.WHITE
	hitbox.monitoring = true

func deactivate_hand(side: String):
	var hand = get_node("Root/Hand"+side)
	var hitbox = hand.get_node("HitBox")
	hand.modulate = Color("#525252")
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


func _on_health_component_hp_changed(health_component: HealthComponent) -> void:
	var health = health_component.hp
	if health <= phase_change_health:
		phase = 2
	
	if health == 0:
		kill()

func _on_hurt(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, stun_time: float, origin: Node) -> void:
	health_component.hp -= damage

func impact():
	print("impact!")
	print(phase)
	if phase >= 2:
		var projectile_count = 6.0
		var bullet_speed = 100.0
		var angle_step = 360.0 / projectile_count
		for i in range(projectile_count):
			var bullet_instance = projectile_scene.instantiate() as Bullet
			
			bullet_instance.velocity = Vector2.RIGHT.rotated(deg_to_rad(angle_step*i)) * bullet_speed
			bullet_instance.phase_through_walls = true
			bullet_instance.owner_type = HitBox.ENEMY_OWNER
			
			Game.singleton.add_child(bullet_instance)
			
			bullet_instance.global_position = floor_position.global_position
