extends Control

@export_file_path("*.tscn") var game_scene: String
@onready var continue_game_button: Button = $VBoxContainer/ContinueGameButton
@onready var start_game_button: Button = $VBoxContainer/StartGameButton

func _ready() -> void:
	if can_continue:
		continue_game_button.grab_focus()
	else:
		start_game_button.grab_focus()
		continue_game_button.disabled = true

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


func can_continue() -> bool:
	var save_path = Game.DEBUG_SAVE_PATH if OS.is_debug_build() else Game.SAVE_PATH 
	return FileAccess.file_exists(save_path)
