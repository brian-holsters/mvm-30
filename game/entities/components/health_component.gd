extends Node

signal hp_reached_0
signal hp_changed

@export var max_hp: int
@export var hp: int:
	set(val):
		var old_hp = hp
		hp = clamp(val, 0, max_hp)
		if hp != old_hp:
			hp_changed.emit()
			if hp == 0:
				hp_reached_0.emit()
