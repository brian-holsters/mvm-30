extends Control


func _on_continue_pressed() -> void:
	EventHub.game_unpaused.emit()


func _on_exit_pressed() -> void:
	pass # Replace with function body.
