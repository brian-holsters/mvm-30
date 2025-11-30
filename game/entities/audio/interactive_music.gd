#interactive_music.gd
extends AudioStreamPlayer
class_name InteractiveMusic

const exploration_index := 0
const combat_index := 1

# progression_var value (0.0 to 1.0)
@export var progression_var: float = 0.0
@export var danger_var: float = 0.0
@export var boss_fight: bool = false
var prog: float = 0.0
var danger: float = 0.0

var exploration_music: AudioStream
var combat_music: AudioStream
var clip_count = 0
var clip_index = 0
var last_index = 0
var init_prog: float = 0.0

func _ready():
	exploration_music = stream.get_sync_stream(exploration_index)
	combat_music = stream.get_sync_stream(combat_index)
	
	clip_count = exploration_music.get_clip_count()	

func _process(_delta):
	progression_var = AudioController.progression
	#print("prog :"+str(progression_var))
	prog = check_var(prog, progression_var)
	danger = check_var(danger, danger_var)
	if stream:
		adapt_explore_music()
		adapt_combat_music()

func choose_music_clip(music):
	if not playing:
		return
	
	if clip_count == 0:
		return
	
	last_index = clip_index
	
	clip_index = round(prog*(clip_count-1))
		
	#print("clip index : "+str(clip_index))

	if last_index != clip_index:
		switch_clip(music, clip_index)

func switch_clip(music, index):
	music.get_stream_playback().switch_to_clip(index)
		
func check_var(private: float,public: float) -> float:
	#print("checking private var :"+str(private)+" and public var: "+str(public))
	if abs(private-public)<0.02:
		private = public
	private = lerpf(private, public, 0.07)
	#print("returning :"+str(private))
	return private

func adapt_explore_music():
	choose_music_clip(exploration_music)
	var synth_volume := 0.0
	if prog >= 0.5:
		synth_volume = 2*(prog-0.5)
	else:
		synth_volume = 2*prog
	#print("synth volume : "+str(synth_volume))
	var x = 0
	while x < clip_count:
		exploration_music.get_clip_stream(x).set_sync_stream_volume(2,-20+20*synth_volume)
		x+=1

func adapt_combat_music():
	var explore_volume := -(40*pow(danger,3.0))
	var combat_volume := 40*pow(danger,0.3)-40
	#print("explore_volume: "+str(explore_volume))
	#print("combat_volume: "+str(combat_volume))
	set_explore_volume(explore_volume)
	set_combat_volume(combat_volume)
	
	#bass only for the boss
	if boss_fight:
		set_bass_volume(0.0)
	else:
		set_bass_volume(-40.0)
	
func set_explore_volume(volume):
	set_track_volume(exploration_index,volume)
	#print("setting explore volume")
	
func set_combat_volume(volume):
	set_track_volume(combat_index,volume)
	#print("setting combat volume")
	
func set_track_volume(index,volume):
	stream.set_sync_stream_volume(index,volume)
	#print("volume : "+str(stream.get_sync_stream_volume(index)))

func set_bass_volume(volume):
	combat_music.set_sync_stream_volume(1,volume)
	print("bass volume : "+str(combat_music.get_sync_stream_volume(1)))
