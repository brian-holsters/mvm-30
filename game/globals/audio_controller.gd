extends Node

const MIN_ENEMY_DISTANCE = -50.0
const MAX_ENEMY_DISTANCE = 350.0

enum MusicState {
	START,
	EXPLORE,
	FIRST_UPGRADE,
	BOSS,
	SILENCE,
}

#publicly accessible
@export var progression_var: float = 0.0
@export var danger_var: float = 0.0

#progression and danger between 0.0 and 1.0 - calculated from the public
#variables after smoothing out
var progression: float = 0.0
var danger_level: float = 0.0

var intro_complete: bool = false
var dash_obtained: bool = false
var intro_chkr: FlagNode
var dash_chkr: FlagNode
var state: MusicState = MusicState.START
var enemy_distance: float = MAX_ENEMY_DISTANCE

#--------------------------------------------------------
#internal object

#to smooth out variable changes
func change_var(private: float,public: float, factor := 0.05) -> float:
	#print("checking private var :"+str(private)+" and public var: "+str(public))
	if abs(private-public)<0.02:
		private = public
	private = lerpf(private, public, factor)
	#print("returning :"+str(private))
	return private
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_chkr = FlagNode.new()
	intro_chkr.flag = "intro_complete"
	#intro_chkr.set_flag()
	add_child(intro_chkr)
	intro_complete = intro_chkr.get_flag_value()
	#print("intro_complete: "+str(intro_complete))
	
	dash_chkr = FlagNode.new()
	dash_chkr.database = "upgrades"
	dash_chkr.flag = "Dash"
	#dash_chkr.set_flag()
	add_child(dash_chkr)
	dash_obtained = dash_chkr.get_flag_value()
	#print("dash_obtained: "+str(dash_obtained))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#checking progression and danger level, smoothing out transitions
	progression = change_var(progression, progression_var, 0.07)
	danger_level = change_var(danger_level, danger_var, 0.07)
	
	#print("music state: "+str(state))
	#print("progression_var: "+str(progression_var))
	#print("progression: "+str(progression))
	#print("danger_var: "+str(danger_var))
	#print("danger_level: "+str(danger_level))
	
	match state:
		MusicState.START:
			intro_complete = intro_chkr.get_flag_value()
			if intro_complete:
				set_state(MusicState.EXPLORE)
		MusicState.EXPLORE:
			dash_obtained = dash_chkr.get_flag_value()
			if dash_obtained:
				set_state(MusicState.FIRST_UPGRADE)
			set_danger(danger_from_distance())
		MusicState.FIRST_UPGRADE:
			set_danger(danger_from_distance())
		MusicState.BOSS:
			pass
		MusicState.SILENCE:
			pass
		"_":
			state = MusicState.START		

func set_state(new_state: MusicState):
	if new_state == state:
		return
	_exit_state(state)
	state = new_state
	_enter_state(state)

func get_state() -> MusicState:
	return state
	
func _enter_state(s):
	print("enter state: "+str(s))
	match s:
		MusicState.START:
			set_progression(0.0)
			set_danger(0.0)
		MusicState.EXPLORE:
			set_progression(1.0)
		MusicState.FIRST_UPGRADE:
			set_progression(0.5)
			set_danger(danger_from_distance())
		MusicState.BOSS:
			set_danger(1.0)
		MusicState.SILENCE:
			pass

func _exit_state(s):
	print("exit state: "+str(s))
	match s:
		MusicState.START:
			pass
		MusicState.EXPLORE:
			pass
		MusicState.BOSS:
			pass
			set_danger(0.0)
		MusicState.SILENCE:
			pass

func danger_from_distance():
		var dist_fact = clamp((enemy_distance-MIN_ENEMY_DISTANCE)/(MAX_ENEMY_DISTANCE-MIN_ENEMY_DISTANCE),0.0,1.0)
		var result = (1.0-dist_fact)
		#print("result: "+str(result))
		return result
	
func set_danger(value: float):
	danger_var = value
	
func set_progression(value: float):
	progression_var = value
	
#----------------------------------------------------------------
#public interface

func set_enemy_distance(distance):
		enemy_distance = distance
		#print("closest enemy distance: "+str(distance))


func enable_music():
	set_state(MusicState.START)
	
func disable_music():
	set_state(MusicState.SILENCE)
	
func check_music_enabled():
	return (not state == MusicState.SILENCE)
	
func start_boss_battle():
	set_state(MusicState.BOSS)

func end_boss_battle():
	set_state(MusicState.START)

func reset_music():
	intro_complete = false
	dash_obtained = false
	enemy_distance = MAX_ENEMY_DISTANCE
	set_state(MusicState.START)
	
func get_progression() -> float :
	return progression
	
func get_danger() -> float :
	return danger_level
