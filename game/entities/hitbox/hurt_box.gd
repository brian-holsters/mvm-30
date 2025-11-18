extends Area2D
class_name HurtBox

# Hurtboxes are passive, hitboxes are in charge of signalling
signal hurt(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, origin: Node)
