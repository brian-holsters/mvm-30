extends Area2D
class_name HitBox

signal hit(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, target: HurtBox)

@export var custom_knockback := false
@export var directional_knockback := true
@export var knockback: Vector2 = Vector2.ZERO
@export var damage: int = 1
@export var origin: Node  ## Used for directional knockback

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is HurtBox:
		hit.emit(custom_knockback, directional_knockback, knockback, damage, area)
		var _origin = origin if origin != null else self
		area.hurt.emit(custom_knockback, directional_knockback, knockback, damage, _origin)
