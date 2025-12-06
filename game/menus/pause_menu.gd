extends Control

func refocus():
	$VBoxContainer/Continue.grab_focus()

func _on_continue_pressed() -> void:
	EventHub.game_unpaused.emit()


func _on_exit_pressed() -> void:
	Game.singleton.exit_game()
