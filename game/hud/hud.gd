extends CanvasLayer

@export var hp_gauge: Control
@export var player: MvmPlayer

func _ready() -> void:
	hp_gauge.player = player
	player.hp_changed.connect(hp_gauge.update)

func update():
	hp_gauge.update()
