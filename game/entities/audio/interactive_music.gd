#interactive_music.gd
extends AudioStreamPlayer
class_name InteractiveMusic

const exploration_index := 0
const combat_index := 1

# progression_var value (0.0 to 1.0)
@export var boss_fight: bool = false
var state : AudioController.MusicState
var prog: float = 0.0
var danger: float = 0.0

var clip_count = 0
var clip_index = 0
var last_index = 0
var init_prog: float = 0.0

func _ready():
	pass

func _process(_delta):
	state = AudioController.get_state()
	boss_fight = (state == AudioController.MusicState.BOSS)
	prog = AudioController.get_progression()
	danger = AudioController.get_danger()
	if stream:
		if AudioController.check_music_enabled():
			adapt_explore_music()
			adapt_combat_music()
		else:
			seek(0.0)
			set_explore_volume(-60)
			set_combat_volume(-60)

func choose_music_clip(music):
	if not playing:
		return
	
	clip_count = music.get_clip_count()
	if clip_count == 0:
		return
	#print("clip_count: "+str(clip_count))
	last_index = clip_index
	
	clip_index = round(prog*(clip_count-1))
	
	#print("clip index : "+str(clip_index))

	if last_index != clip_index:
		switch_clip(music, clip_index)

func switch_clip(_music, index):
	
	get_stream_playback().switch_to_clip(index)

func adapt_explore_music():
	choose_music_clip(stream)
	var synth_volume := 0.0
	if prog >= 0.5:
		synth_volume = 2.0*(prog-0.5)
	else:
		synth_volume = 2.0*prog
	#print("synth volume : "+str(synth_volume))
	var x = 0
	while x < clip_count:
		get_current_exploration_stream().set_sync_stream_volume(2,scale_percent_to_db_volume(synth_volume,-20,0))
		x+=1

func adapt_combat_music():
	var explore_volume = (scale_percent_to_db_volume(danger,0.0,-40.0))
	var combat_volume = (scale_percent_to_db_volume(danger,-40.0,0.0))
	#print("danger: "+str(danger))
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
	set_track_volume(get_current_part_stream(),exploration_index,volume)
	#print("setting explore volume")
	
func set_combat_volume(volume):
	set_track_volume(get_current_part_stream(),combat_index,volume)
	#print("setting combat volume: "+str(volume))
	
func set_track_volume(part,index,volume):
	part.set_sync_stream_volume(index,volume)
	#print("volume : "+str(stream.get_sync_stream_volume(index)))

func set_bass_volume(volume):
	get_current_combat_stream().set_sync_stream_volume(1,volume)
	#print("bass volume : "+str(get_current_exploration_stream().get_sync_stream_volume(1)))

func scale_percent_to_db_volume(input: float, min_db: float, max_db: float, smooth_level: float = 3):
		#print("scale_percent_to_db_volume from :"+str(input)+" with min_db : "+str(min_db)+" and max_db : "+str(max_db))
		var spread := max_db-min_db
		var smooth_var := 0.0
		var volume := 0.0
		var level := 0.0
		if spread < 0:
			#print("lowering volume with input")
			smooth_var= smooth_level
			level = pow(input,smooth_var)
			volume = min_db-(abs(spread)*level)
		else:
			#print("raising volume with input")
			smooth_var = 1.0/smooth_level
			level = pow(input,smooth_var)
			volume = (abs(spread)*level)+min_db
		#print("volume :"+str(volume))
		return volume

func get_current_exploration_stream():
	var exploration_stream = stream.get_clip_stream(get_stream_playback().get_current_clip_index()
).get_sync_stream(exploration_index)
	return exploration_stream

func get_current_combat_stream():
	#print(get_stream_playback().get_current_clip_index())
	var combat_stream = stream.get_clip_stream(get_stream_playback().get_current_clip_index()
).get_sync_stream(combat_index)
	return combat_stream

func get_current_part_stream():
	var current_stream = stream.get_clip_stream(get_stream_playback().get_current_clip_index()
)
	return current_stream
