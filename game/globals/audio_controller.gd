extends Node

const MIN_ENEMY_DISTANCE = -50.0
const MAX_ENEMY_DISTANCE = 350.0

#progression between 0.0 and 1.0
var progression: float = 0.0
var intro_complete: bool = false
var boss_battle: bool = false
var intro_chkr: FlagNode
var state: String = "start"
var enemy_distance: float = MAX_ENEMY_DISTANCE
var danger_level: float = 0.0

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
			progression = 1.0
			if boss_battle:
				set_state("boss")
		"boss":
			danger_level = 1.0
			if not boss_battle:
				set_state("explore")
		"_":
			state = "start"		

func set_state(new_state):
	state = new_state
	print("music state: "+str(state))

func set_enemy_distance(distance):
	if distance < MAX_ENEMY_DISTANCE:
		enemy_distance = min(distance, enemy_distance)
		#print("closest enemy distance: "+str(distance))
		var dist_fact = clamp((distance-MIN_ENEMY_DISTANCE)/(MAX_ENEMY_DISTANCE-MIN_ENEMY_DISTANCE),0.0,1.0)
		danger_level = 1.0-dist_fact
		#print("danger_level: "+str(danger_level))
