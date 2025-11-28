@tool
extends SignalStateTransition


func _on_signal(_a: bool, _b: bool, _c: Vector2, damage: int, stun_time: float, origin: Node2D, _g, _h, _i, _j):
	var processed_data := get_all_data().duplicate(true)
	processed_data["damage"] = damage
	processed_data["stun_time"] = stun_time
	processed_data["origin_position"] = origin.global_position
	state_machine.request_state_change(to_state.name, processed_data, priority, override_same_priority)
