extends Node2D

var player: MvmPlayer
@onready var text_player: Node = $TextPlayer
@onready var text_player_2: Node = $TextPlayer2
@onready var gate: TileMapLayer = %Gate
@onready var text_played_flag: FlagNode = $TextPlayedFlag

var intro_text_finished = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as MvmPlayer
	player.state_machine.state_changed.connect(_on_player_state_machine_changed)
	text_player.play_timeline()
	await Dialogic.signal_event
	intro_text_finished = true

func _on_player_state_machine_changed(from: StringName, to: StringName):
	match [from, to]:
		["Grounded", "JumpSquat"]:
			if text_played_flag.get_flag_value() or not intro_text_finished:
				return
			text_played_flag.set_flag()
			text_player_2.play_timeline()
			await Dialogic.signal_event
			gate.queue_free()
