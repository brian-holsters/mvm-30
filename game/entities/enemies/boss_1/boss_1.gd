extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_position: Marker2D = $PlayerPosition

signal target_reached

var active := false:
	set(val):
		var was_active = active
		active = val
		if not was_active and active:
			next_move()
var moving := false
var target: Vector2
var probability_list := []
var probability_list_max_size: int
var movement_speed := 5.0

func _ready() -> void:
	deactivate_hand("L")
	deactivate_hand("R")
	reset_probability_list()
	animation_player.animation_finished.connect(next_move.unbind(1))
	target_reached.connect(set.bind("moving", false))


func _physics_process(_delta: float) -> void:
	if moving:
		global_position = global_position.move_toward(target, movement_speed)
		if global_position.distance_to(target) <= 3.0:
			target_reached.emit()


func next_move():
	deactivate_hand("L")
	deactivate_hand("R")
	move_to_player()
	await target_reached
	var _next_move = get_next_move()
	animation_player.play(_next_move)


func get_next_move():
	if probability_list.size() <= probability_list_max_size/2:
		reset_probability_list()
	var _next_move = probability_list.pick_random()
	probability_list.remove_at(probability_list.find(_next_move))
	return _next_move


func move_to_player():
	target = MetSys.exact_player_position - player_position.position
	moving = true


func reset_probability_list():
	var animations = Array(animation_player.get_animation_list())
	probability_list = []
	for i in range(3):
		probability_list += animations


func activate_hand(side: String):
	var hand = get_node("Root/Hand"+side)
	var hitbox = hand.get_node("HitBox")
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
