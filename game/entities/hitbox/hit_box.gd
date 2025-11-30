extends Area2D
class_name HitBox

const PLAYER_OWNER = "player"
const ENEMY_OWNER = "enemy"

const collision_layers = {
	PLAYER_OWNER: 4,
	ENEMY_OWNER: 16
}

const collision_masks = {
	PLAYER_OWNER: 32,
	ENEMY_OWNER: 8
}



signal hit(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, stun_time: float, target: HurtBox)
@export_enum(PLAYER_OWNER, ENEMY_OWNER) var owner_type := ENEMY_OWNER:
	set(val):
		owner_type = val
		collision_layer = collision_layers[val]
		collision_mask = collision_masks[val]


@export_group("Custom Knockback")
@export var custom_knockback := false
@export var directional_knockback := true
@export var knockback: Vector2 = Vector2.ZERO
@export var damage: int = 1
@export var stun_time: float = 0.2
@export var origin: Node  ## Used for directional knockback

func _ready() -> void:
	collision_layer = collision_layers[owner_type]
	collision_mask = collision_masks[owner_type]
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is HurtBox:
		hit.emit(custom_knockback, directional_knockback, knockback, damage, stun_time, area)
		var _origin = origin if origin != null else self
		area.hurt.emit(custom_knockback, directional_knockback, knockback, damage, stun_time, _origin)
