extends Area2D
class_name DangerZone2D

var in_range : bool = false
var player

@onready var collision_shape = $CollisionShape2D

@export var boss_zone := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	collision_shape.shape.radius = AudioController.MAX_ENEMY_DISTANCE

func _process(_delta) -> void:
	if in_range and player:
		var distance = global_position.distance_to(player.global_position)
		#print("distance between player and enemy: "+str(distance))
		AudioController.set_enemy_distance(distance)
		AudioController.boss_battle = AudioController.boss_battle or boss_zone
	else:
		AudioController.boss_battle = false
		
func _on_body_entered(body: Node2D):
	if body is MvmPlayer:
		#print("entered range")
		in_range = true
		player = body

func _on_body_exited(body: Node2D):
	if body is MvmPlayer:
		#print("left range")
		in_range = false

func  _exit_tree():
	AudioController.set_enemy_distance(AudioController.MAX_ENEMY_DISTANCE)
	AudioController.danger_level=0.0
	AudioController.boss_battle = false
