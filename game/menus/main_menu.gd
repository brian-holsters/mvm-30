extends Control

@export_file_path("*.tscn") var game_scene: String


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)
