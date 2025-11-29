extends Node

#progression between 0.0 and 1.0
var progression: float = 0.0
var intro_complete: bool = false
var boss_battle: bool = false
var intro_chkr: FlagNode
var state: String = "start"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_chkr = FlagNode.new()
	intro_chkr.flag = "intro_complete"
	#intro_chkr.set_flag()
	add_child(intro_chkr)
	intro_complete = intro_chkr.get_flag_value()
	#print("intro_complete: "+str(intro_complete))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print("music state: "+str(state))
	match state:
		"start":
			intro_complete = intro_chkr.get_flag_value()
			if intro_complete:
				set_state("explore")
		"explore":
			progression = 0.5
			if boss_battle:
				set_state("boss")
		"boss":
			progression = 0.49
			if not boss_battle:
				set_state("explore")
		"_":
			state = "start"		

func set_state(new_state):
	state = new_state
	print("music state: "+str(state))
