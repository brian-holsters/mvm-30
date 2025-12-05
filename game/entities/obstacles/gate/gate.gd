@tool
extends Node2D
class_name Gate

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var top_sprite: Sprite2D = %TopSprite
@onready var middle_sprite: Sprite2D = %MiddleSprite
@onready var bottom_sprite: Sprite2D = %BottomSprite
@onready var open_sfx: AudioStreamPlayer2D = %OpenSFX
@onready var static_body_2d: StaticBody2D = %StaticBody2D
@onready var visuals: Node2D = %Visuals

@export var time_to_open: float = 0.5
@export var height: int = 2: set = _set_height

func _ready() -> void:
	collision_shape_2d.shape = collision_shape_2d.shape.duplicate()

func _set_height(val):
	if not is_node_ready():
		await ready
	height = max(2, val)
	top_sprite.position.y = (-20 * (float(height) / 2)) + 10
	bottom_sprite.position.y = (20 * (float(height) / 2)) - 10
	collision_shape_2d.shape.size.y = 20 * height
	if height > 2:
		middle_sprite.scale.y = height - 2
		middle_sprite.show()
	else:
		middle_sprite.hide()

func open_down():
	var target = Vector2(0, (height * 20))
	open(target)

func open_up():
	var target = Vector2(0, -(height * 20))
	open(target)

func open(target):
	collision_shape_2d.set_deferred("disabled", true)
	var tween = create_tween()
	
	tween.tween_property(visuals, "position", target, time_to_open)
	open_sfx.play()
