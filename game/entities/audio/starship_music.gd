extends Node

@onready var intro_complete_flag: FlagNode = $IntroCompleteFlag
@onready var music: AudioStreamPlayer = $InteractiveMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_intro_complete_flag_flag_checked() -> void:
	start_synths()


func _on_intro_complete_flag_flag_just_checked() -> void:
	start_synths()

func start_synths():
	print("start")
	music.progression_var = 0.49
