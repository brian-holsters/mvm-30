extends HitBox

@export var respawn_point: Node2D

func _on_area_entered(area: Area2D):
	super(area)
	if area is HurtBox:
		await get_tree().create_timer(stun_time).timeout
		area.actor.global_position = respawn_point.global_position
