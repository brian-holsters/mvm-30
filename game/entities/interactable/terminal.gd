extends InteractableArea2D
class_name Terminal

@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var interact_text: Label = $InteractText
@onready var ever_interacted: FlagNode = $EverInteracted


func _ready() -> void:
	super()
	interact_text.hide()
	interact.connect(_on_terminal_interact.unbind(1))
	can_interact.connect(interact_text.show)
	cannot_interact.connect(interact_text.hide)


func _on_terminal_interact():
	audio_stream_player_2d.play()
	deactivate()

func _on_body_entered(body: Node):
	super(body)
	if not ever_interacted.get_flag_value():
		EventHub.tutorial_text.emit("Press [W] to interact")
		ever_interacted.set_flag()
