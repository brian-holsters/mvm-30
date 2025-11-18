@tool
extends "res://addons/bluebrains_character_controller/character_controller/state_machine/signal_transition.gd"

func _on_signal(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, origin: Node, _f, _g, _h, _i, _j):
	if not _should_run():
		return
	if not use_custom_knockback:
		change_state()
	var processed_data := get_all_data().duplicate(true)
	
	if knockback_is_directional:
		var directional_sign = -1 if origin.global_position.x > parent.actor.global_position.x else 1
		knockback = Vector2(knockback.x * directional_sign, knockback.y)
	
	processed_data["knockback"] = knockback
	processed_data["damage"] = damage
	
	state_machine.request_state_change(to_state.name, processed_data, priority, override_same_priority)
