extends Node2D

@onready var escape_flag: FlagNode = %EscapeFlag
@onready var spawn_setter: SpawnSetter = %SpawnSetter

var escape_countdown: PackedScene = load("res://game/hud/count_down.tscn")

func _ready() -> void:
	if escape_flag.get_flag_value():
		start_escape()


func start_escape() -> void:
	var count_down = escape_countdown.instantiate()
	Game.singleton.hud.get_node("HudControl").add_child(count_down)
	count_down.add_to_group("count_down")
	count_down.timeout.connect(Game.singleton.exit_game)
	AudioController.start_escape_sequence()
