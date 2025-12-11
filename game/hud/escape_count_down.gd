extends Label

signal timeout

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var minutes = int(timer.time_left / 60)
	var seconds = int(timer.time_left) % 60
	text = "%02d:%02d" % [minutes, seconds]

func _timeout():
	timeout.emit()
