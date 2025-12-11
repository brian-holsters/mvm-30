extends Node

@onready var first_terminal_flag: FlagNode = $FirstTerminalFlag
@onready var second_terminal_flag: FlagNode = $SecondTerminalFlag

func _progress() ->void:
	if second_terminal_flag.get_flag_value():
		return
	elif first_terminal_flag.get_flag_value():
		second_terminal_flag.set_flag()
	else:
		first_terminal_flag.set_flag()
		
