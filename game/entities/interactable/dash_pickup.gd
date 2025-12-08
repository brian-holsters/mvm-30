extends Terminal
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var text_player_node: TextPlayerNode = $TextPlayerNode

func _on_terminal_interact():
	super()
	text_player_node.play_timeline()
	EventHub.tutorial_text.emit("Press [shift] to dash")

func deactivate():
	sprite_2d_2.show()
	super()
