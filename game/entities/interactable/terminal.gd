extends InteractableArea2D
class_name Terminal

@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var interact_text: Label = $InteractText

var deactivated := false

func _ready() -> void:
	super()
	interact.connect(_on_terminal_interact.unbind(1))
	can_interact.connect(interact_text.show)
	cannot_interact.connect(interact_text.hide)

func deactivate():
	deactivated = true
	if _can_interact:
		_can_interact = false
	monitoring = false

func _on_terminal_interact():
	audio_stream_player_2d.play()

func _on_body_entered(body: Node):
	if deactivated:
		return
	super(body)
