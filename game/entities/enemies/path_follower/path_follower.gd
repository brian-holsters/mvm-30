extends PathFollow2D

@export var movement_speed: float = 1  ## Pixels per frame
@export var turnaround_with_direction := true:
	set(val):
		turnaround_with_direction = val
		if not turnaround_with_direction:
			scale.x = abs(scale.x)

func get_speed():
	var slow_margin = movement_speed * 20
	var slow_speed = movement_speed / 2
	var remaining = get_distance_to_closest_edge()
	if remaining >= slow_margin:
		return movement_speed
	return lerp(slow_speed, movement_speed, remaining / slow_margin)


func get_remaining_path_length(direction):
	if direction > 0:
		return get_parent().curve.get_baked_length() - progress
	else:
		return progress


func get_directional_progress(direction):
	if direction > 0:
		return progress
	else:
		return get_parent().curve.get_baked_length() - progress


func get_distance_to_closest_edge():
	var distance_to_0 = progress
	var distance_to_n = get_parent().curve.get_baked_length() - progress
	return distance_to_0 if distance_to_0 < distance_to_n else distance_to_n
