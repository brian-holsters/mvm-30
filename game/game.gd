extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name Game
@onready var hud: CanvasLayer = %Hud

# The game starts in this map. Uses special annotation that enabled dedicated inspector plugin.
@export_file("room_link") var starting_map: String
@export var _player: MvmPlayer
@export var camera: Camera2D

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")
const SAVE_PATH = "user://save_data.sav"
const DEBUG_SAVE_PATH = "res://save_data.txt"

static var save_manager: SaveManager = SaveManager.new()

func _ready() -> void:
	EventHub.flag_changed.connect(_on_flag_change)
	# Basic MetSys initialization
	MetSys.reset_state()
	set_player(_player)
	player.died.connect(_on_death)
	add_module("RoomTransitions.gd")  # TODO: handle transitions more elegantly
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)

func go_to_starting_room(room: String = ""):
	if room == "":
		room = starting_map
	await load_room(room)
	var spawn_point = get_tree().get_first_node_in_group("spawn_point")
	if spawn_point:
		player.global_position = spawn_point.global_position

func new_game():
	# Basic MetSys initialization
	MetSys.reset_state()
	MetSys.set_save_data()
	save_manager = SaveManager.new()
	save_manager.store_game(self)
	hud.update()
	await go_to_starting_room()

func continue_game():
	MetSys.reset_state()
	save_manager = SaveManager.new()
	load_game_data()
	var start = save_manager.data.get("spawn_room", starting_map)
	hud.update()
	await go_to_starting_room(start)

func save_game_data():
	if OS.is_debug_build():
		save_manager.save_as_text(DEBUG_SAVE_PATH)
	else:
		save_manager.save_as_binary(SAVE_PATH)

func load_game_data():
	if OS.is_debug_build():
		save_manager.load_from_text(DEBUG_SAVE_PATH)
	else:
		save_manager.load_from_binary(SAVE_PATH)
	player.load_data()

func init_room():
	save_game_data()
	MetSys.get_current_room_instance().adjust_camera_limits(camera)
	if "on_enter" in player:  # TODO: figure out if on_enter is needed.
		player.on_enter()
	
	# Initializes MetSys.get_current_coords(), so you can use it from the beginning.
	if MetSys.last_player_position.x == Vector2i.MAX.x:
		MetSys.set_player_position(player.position)

func _on_flag_change(database, flag):
	match [database, flag]:
		["upgrades", _]:
			player.unlock_ability(flag)
		["flags", _]:
			pass

func _on_death():
	get_tree().change_scene_to_file.call_deferred("res://game/menus/main_menu.tscn")
