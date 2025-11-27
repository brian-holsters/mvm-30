extends Node

@onready var voice: AudioStreamPlayer = $voice_bg
@onready var synth: AudioStreamPlayer = $synth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	synth.set_volume_db(-80)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_flag_set() -> void:
		print("start synths")
		synth.set_volume_db(0)
		print(synth.volume_db)
		
