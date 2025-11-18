extends Control

@export_file_path("*.tscn") var game_scene: String


func _on_start_game_button_pressed() -> void:
	var game = init_game()
	get_tree().current_scene = game
	game.new_game()
	queue_free()


func _on_continue_game_button_pressed() -> void:
	var game = init_game()
	get_tree().current_scene = game
	game.continue_game()
	queue_free()


func init_game() -> Game:
	var _game_scene = load(game_scene) as PackedScene
	var game_scene_instance = _game_scene.instantiate()
	get_tree().root.add_child(game_scene_instance)
	return game_scene_instance as Game
