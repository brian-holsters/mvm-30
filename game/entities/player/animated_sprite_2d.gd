extends AnimatedSprite2D

@export var walk_frames: Array[int] = [1,5]
@export var grounded_state: CharacterControllerState
@onready var state_machine: CharacterControllerStateMachine = %StateMachine

func _ready() -> void:
	state_machine.state_changed.connect(_on_state_machine_state_change)


func _on_frame_changed() -> void:
	if state_machine.current_state == grounded_state.name:
		if frame in walk_frames:
			%FootstepsAudio.play()


func _on_state_machine_state_change(old, new):
	match [old, new]:
		["Airborne", "Grounded"]:
			%LandingAudio.play()
