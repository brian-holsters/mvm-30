@tool
extends Node2D

var _required_exports: Array[String] = ["hitbox"]

@onready var visual_l_sprite: Sprite2D = %VisualLSprite
@onready var visual_r_sprite: Sprite2D = %VisualRSprite
@onready var laser_sprite: Sprite2D = %LaserSprite

@export var hitbox: HitBox:
	set(val):
		hitbox = val
		update_configuration_warnings()
@export_group("Configuration")
@export_tool_button("Autodetect Length") var auto_length = autodetect_length
@export_tool_button("Center Hitbox") var center = center_hitbox
@export_range(2, 10000, 2) var length: int = 50: set = _set_length
@export var show_left: bool = true:
	set(val):
		show_left = val
		visual_l_sprite.visible = show_left
@export var show_right: bool = true:
	set(val):
		show_right = val
		visual_r_sprite.visible = show_right

## Only set this up in laser scene, this needs to be aligned with sfx and vfx
@export var prep_time: float = 0.0
@export_group("State")
@export var active: bool = true:
	set(val):
		if val == active:
			return
		active = val
		if not is_node_ready():
			await ready
		if active:
			activate()
		else:
			deactivate()


func toggle():
	active = not active


func activate():
	if prep_time > 0.0:
		# TODO: add code to be exexuted before activation here
		await get_tree().create_timer(prep_time).timeout
	active = true
	laser_sprite.show()
	if hitbox:
		hitbox.monitoring = true


func deactivate():
	laser_sprite.hide()
	if hitbox:
		hitbox.monitoring = false
	active = false


func _ready() -> void:
	visual_l_sprite.visible = show_left
	visual_r_sprite.visible = show_right

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	return warnings


func autodetect_length():
	if not hitbox:
		print("No hitbox found")
		return
	var collision_shape = hitbox.get_node_or_null("CollisionShape2D")
	if not collision_shape is CollisionShape2D or not collision_shape.shape is RectangleShape2D:
		print("autodetect length requires the hitbox to use a RectangleShape2D")
		return
	length = int(ceilf(collision_shape.shape.size.x))


func center_hitbox():
	if not hitbox:
		return
	hitbox.global_position = global_position
	var collision_shape = hitbox.get_node_or_null("CollisionShape2D")
	if not collision_shape is CollisionShape2D:
		return
	collision_shape.position = Vector2.ZERO


func _set_length(val):
	length = val
	if not is_node_ready():
		await ready
	visual_l_sprite.position.x = -length/2
	visual_r_sprite.position.x = length/2
	laser_sprite.scale.x = length/2
