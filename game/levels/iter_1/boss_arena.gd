extends Node2D

@onready var boss_kill_flag: FlagNode = %BossKillFlag
@onready var boss: Node2D = $Boss
@onready var boss_start: Terminal = $BossStart
@onready var exit_gate: Gate = %ExitGate

func _ready() -> void:
	if not boss_kill_flag.get_flag_value():
		AudioController.disable_music()


#region Boss fight
func _on_boss_start_interact():
	boss_start.deactivate()
	boss.active = true
	AudioController.start_boss_battle()


func _on_boss_killed() -> void:
	AudioController.end_boss_battle()
	boss_kill_flag.set_flag()
	exit_gate.open_up()
	#AudioController.start_escape_sequence()
#endregion


# When entering the room after killing the boss
func _on_boss_kill_flag_flag_checked() -> void:
	if not is_node_ready():
		await ready
	boss_start.deactivate()
	boss.queue_free()
	exit_gate.queue_free()
