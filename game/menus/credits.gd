extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal finished

func play():
	animation_player.play("scroll")
	await animation_player.animation_finished
	finished.emit()
