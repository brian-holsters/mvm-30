@tool
extends SignalStateTransition

func _on_signal(use_custom_knockback: bool, knockback_is_directional: bool, knockback: Vector2, damage: int, stun_time: float, origin: Node, _g, _h, _i, _j):
	if not _should_run():
		return
	var processed_data := get_all_data().duplicate(true)
	processed_data["damage"] = damage

	if not use_custom_knockback:
		state_machine.request_state_change(to_state.name, processed_data, priority, override_same_priority)
	
	if knockback_is_directional:
		var directional_sign = -1 if origin.global_position.x > parent.actor.global_position.x else 1
		knockback = Vector2(knockback.x * directional_sign, knockback.y)
	
	processed_data["knockback"] = knockback
	processed_data["stun_time"] = stun_time
	
	state_machine.request_state_change(to_state.name, processed_data, priority, override_same_priority)
