extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name Game

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
	
	add_module("RoomTransitions.gd")  # TODO: handle transitions more elegantly
	
	# TODO: Save file handling
	
	MetSys.set_save_data()
	save_manager = SaveManager.new()
	save_manager.store_game(self)
	save()
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)
	# Load the starting room.
	await load_room(starting_map)
	var spawn_point = get_tree().get_first_node_in_group("spawn_point")
	if spawn_point:
		player.global_position = spawn_point.global_position

func save():
	if OS.is_debug_build():
		save_manager.save_as_text(DEBUG_SAVE_PATH)
	else:
		save_manager.save_as_binary(SAVE_PATH)

func init_room():
	save()
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
