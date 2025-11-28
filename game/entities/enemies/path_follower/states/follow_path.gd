@tool
extends CharacterControllerState


var direction = 1:  # sign to control going forward or backward
	set(val):
		direction = val
		if actor.turnaround_with_direction:
			actor.scale.x = direction * abs(actor.scale.x)


func physics_tick(_delta: float) -> void:
	var pixels_to_move = actor.movement_speed
	var reached_end = false
	if not actor.loop and actor.get_remaining_path_length(direction) < pixels_to_move: # Ping Pong
		pixels_to_move = actor.get_remaining_path_length(direction)
		reached_end = true
	
	actor.progress += pixels_to_move * direction
	
	if reached_end:
		direction = -direction
