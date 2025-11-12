extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"

# The game starts in this map. Uses special annotation that enabled dedicated inspector plugin.
@export_file("room_link") var starting_map: String
@export var _player: MvmPlayer
@export var camera: Camera2D

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")
const SAVE_PATH = "user://example_save_data.sav"

func _ready() -> void:
	# Basic MetSys initialization
	MetSys.reset_state()
	set_player(_player)
	
	add_module("RoomTransitions.gd")  # TODO: handle transitions more elegantly
	
	# TODO: Save file handling
	MetSys.set_save_data()
	
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)
	# Load the starting room.
	load_room(starting_map)


func init_room():
	MetSys.get_current_room_instance().adjust_camera_limits(camera)
	if "on_enter" in player:  # TODO: figure out if on_enter is needed.
		player.on_enter()
	
	# Initializes MetSys.get_current_coords(), so you can use it from the beginning.
	if MetSys.last_player_position.x == Vector2i.MAX.x:
		MetSys.set_player_position(player.position)
