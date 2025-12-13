extends Node

const PERIOD = 2

var time := 0.0
var sine := 0.0

@onready var alarm_lights = $AlarmLights

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if AudioController.state == AudioController.MusicState.ESCAPE:
		time += delta
		sine = sin(TAU*(time/(2*PERIOD)))**2
		#print(str(sine))
		var color = Color(1.0,1.0-sine/1.5,1.0-sine/1.5,1.0)
		alarm_lights.set_color(color)
	else:
		var color = Color(1.0,1.0,1.0,1.0)
		alarm_lights.set_color(color)
