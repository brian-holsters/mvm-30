extends Node2D

signal opening_finished

@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func open_animated():
	animation_player.play("opening")
	await animation_player.animation_finished
	opening_finished.emit()

func open():
	animation_player.play("open")
