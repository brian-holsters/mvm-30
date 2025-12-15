extends Node
var state
var generator
var radiowaves
var alarm

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generator = $generator
	radiowaves = $radiowaves
	alarm = $alarm


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state = AudioController.state
	if (state == AudioController.MusicState.ESCAPE):
		generator.stop()
		radiowaves.stop()
		start(alarm)
	else:
		start(generator)
		start(radiowaves)
		alarm.stop()

func start(player: AudioStreamPlayer):
	if not(player.playing):
		player.play()
