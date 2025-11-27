#interactive_music_stream.gd
extends AudioStream
class_name InteractiveMusicStream

# progression_var value (0.0 to 1.0)
@export var progression_var: float = 0.0

var clip_index = 0
var last_index = 0

func _ready():
	pass
	

func _process(_delta):
	choose_music_clip()


func choose_music_clip():
	
	var clip_count = get_clip_count()
	if clip_count == 0:
		return
	
	last_index = clip_index
	
	clip_index = round(progression_var*(clip_count-1))
		
	print("clip index : "+str(clip_index))

	if last_index != clip_index:
		switch_clip(clip_index)

func switch_clip(index):
	get_stream_playback().switch_to_clip(index)
	
