extends AnimatedSprite2D

@export var walk_frames: Array[int] = [1,5]
@export var grounded_state: CharacterControllerState
@onready var state_machine: CharacterControllerStateMachine = %StateMachine

var air_counter: float = 0.0
var airborne: bool = false

func _ready() -> void:
	state_machine.state_changed.connect(_on_state_machine_state_change)
	
func _process(delta: float) -> void:
	if airborne:
		air_counter+=delta


func _on_frame_changed() -> void:
	if animation in ["walk", "run"]:
		if frame in walk_frames:
			%FootstepsAudio.play()


func _on_state_machine_state_change(old, new):
	match [old, new]:
		[_, "Airborne"]:
			airborne = true
			air_counter = 0
		["Airborne", "Grounded"]:
			airborne = false
			#print("air_counter: "+str(air_counter))
			%LandingAudio.volume_db=(-4+6*min(air_counter,1.5))
			%LandingAudio.play()
		[_, "Dash"]:
			%DashAudio.play()
		[_, "Hang"]:
			%LedgeGrabAudio.play()
		[_, "Hurt"]:
			%HurtAudio.play()
