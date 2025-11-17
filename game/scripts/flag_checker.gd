extends Node2D
class_name FlagNode

signal flag_checked
signal flag_unchecked
@export var flag: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.save_manager.get_value(flag, false) == true:
		flag_checked.emit()
	else:
		flag_unchecked.emit()

func set_flag():
	Game.save_manager.set_value(flag, true)

func unset_flag():
	Game.save_manager.set_value(flag, false)
