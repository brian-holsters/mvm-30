extends Node2D

var player: MvmPlayer

@onready var intro_text_player: Node = %IntroTextPlayer
@onready var open_door_text_player: Node = %OpenDoorTextPlayer
@onready var text_played_flag: FlagNode = $TextPlayedFlag
@onready var intro_complete_flag: FlagNode = $IntroCompleteFlag
@onready var intro: Node2D = %Intro

var intro_text_finished = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as MvmPlayer
	player.state_machine.state_changed.connect(_on_player_state_machine_changed)

func play_intro():
	if not is_node_ready():
		await ready
	player.hide()
	player.process_mode = Node.PROCESS_MODE_DISABLED
	intro.open_animated()
	
	await intro.opening_finished
	player.show()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	intro_text_player.play_timeline()
	
	await Dialogic.signal_event
	intro_text_finished = true

func _on_player_state_machine_changed(from: StringName, to: StringName):
	match [from, to]:
		["Grounded", "JumpSquat"]:
			if text_played_flag.get_flag_value() or not intro_text_finished:
				return
			text_played_flag.set_flag()
			open_door_text_player.play_timeline()
			await Dialogic.signal_event
			intro_complete_flag.set_flag()
