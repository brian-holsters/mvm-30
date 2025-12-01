extends Node2D

@onready var danger_zone_2d: DangerZone2D = $DangerZone2D
@onready var boss_kill_flag: FlagNode = $BossKillFlag
@onready var boss: Node2D = $Boss
@onready var boss_start: Area2D = $BossStart
@onready var exit_gate: Gate = %ExitGate

func _process(_delta: float) -> void:
	# hacky way to always be 100% in boss fight music:
	danger_zone_2d.global_position = MetSys.exact_player_position

#region Boss fight
func _on_boss_start_body_entered(_body: Node2D):
	boss.active = true
	danger_zone_2d.monitoring = true


func _on_boss_killed() -> void:
	danger_zone_2d.monitoring = false
	boss_kill_flag.set_flag()
	exit_gate.open_up()
#endregion


# When entering the room after killing the boss
func _on_boss_kill_flag_flag_checked() -> void:
	if not is_node_ready():
		await ready
	boss_start.queue_free()
	boss.queue_free()
	exit_gate.queue_free()
