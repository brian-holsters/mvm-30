#interactive_music.gd
extends AudioStreamPlayer
class_name InteractiveMusic

# progression_var value (0.0 to 1.0)
@export var progression_var: float = 0.0
var prog: float = 0.0

var clip_count = 0
var clip_index = 0
var last_index = 0
var lerping: bool = false
var init_prog: float = 0.0

func _ready():
	clip_count = stream.get_clip_count()	

func _process(_delta):
	check_prog()
	if stream:
		choose_music_clip()
		var synth_volume = 0
		if prog >= 0.5:
			synth_volume = 2*(prog-0.5)
		else:
			synth_volume = 2*prog
		#print("synth volume : "+str(synth_volume))
		var x = 0
		while x < clip_count:
			stream.get_clip_stream(x).set_sync_stream_volume(1,-20+20*synth_volume)
			x+=1

func choose_music_clip():
	if not playing:
		return
	
	if clip_count == 0:
		return
	
	last_index = clip_index
	
	clip_index = round(prog*(clip_count-1))
		
	#print("clip index : "+str(clip_index))

	if last_index != clip_index:
		switch_clip(clip_index)

func switch_clip(index):
	get_stream_playback().switch_to_clip(index)
		
func check_prog():
	if lerping == false:
		if prog != progression_var:
			lerping = true
	else:
		prog = lerp(prog, progression_var, 0.05)
		#print("lerping :"+str(prog))
		if abs(prog-progression_var)<0.02:
			lerping = false
			prog = progression_var
	
