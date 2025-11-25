extends Node
class_name FlagNode

signal flag_checked
signal flag_unchecked
@export var database: String = "flags"
@export var flag: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var flags = Game.save_manager.get_value(database, {})
	if flags.get(flag, false) == true:
		flag_checked.emit()
	else:
		flag_unchecked.emit()

func get_flag_value():
	return Game.save_manager.get_value(database, {}).get(flag, false)

func set_flag():
	var flags = Game.save_manager.get_value(database, {})
	flags[flag] = true
	Game.save_manager.set_value(database, flags)
	EventHub.flag_changed.emit(database, flag)

func unset_flag():
	var flags = Game.save_manager.get_value(database, {})
	flags[flag] = false
	Game.save_manager.set_value(database, flags)
	EventHub.flag_changed.emit(database, flag)
