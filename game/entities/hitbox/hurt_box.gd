extends Area2D
class_name HurtBox

@export var actor: Node2D

# Hurtboxes are passive, hitboxes are in charge of signalling
signal hurt(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, stun_time: float, origin: Node)
