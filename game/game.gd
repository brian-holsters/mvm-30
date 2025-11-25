extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name Game

@onready var hud: CanvasLayer = %Hud
@onready var gameplay: Node2D = %Gameplay
@onready var pause_layer: CanvasLayer = %PauseLayer

# The game starts in this map. Uses special annotation that enabled dedicated inspector plugin.
@export_file("room_link") var starting_map: String
@export var _player: MvmPlayer
@export var camera: Camera2D

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")
const SAVE_PATH = "user://save_data.sav"
const DEBUG_SAVE_PATH = "res://save_data.txt"

static var save_manager: SaveManager = SaveManager.new()

enum GAME_STATES {
	GAME, DIALOGUE, PAUSE
}

var previous_game_state: GAME_STATES = GAME_STATES.GAME

var game_state: GAME_STATES = GAME_STATES.GAME:
	set(val):
		game_state = val
		match val:
			GAME_STATES.GAME:
				pause_layer.process_mode = Node.PROCESS_MODE_DISABLED
				pause_layer.hide()
				gameplay.process_mode = Node.PROCESS_MODE_ALWAYS
			GAME_STATES.DIALOGUE:
				pause_layer.process_mode = Node.PROCESS_MODE_DISABLED
				pause_layer.hide()
				gameplay.process_mode = Node.PROCESS_MODE_DISABLED
			GAME_STATES.PAUSE:
				pause_layer.process_mode = Node.PROCESS_MODE_ALWAYS
				pause_layer.show()
				gameplay.process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	########################
	## GAME_STATE
	########################
	EventHub.game_paused.connect(_pause_game)
	EventHub.game_unpaused.connect(_unpause_game)
	
	
	########################
	## METSYS
	########################
	EventHub.flag_changed.connect(_on_flag_change)
	# Basic MetSys initialization
	MetSys.reset_state()
	set_player(_player)
	player.died.connect(_on_death)
	add_module("RoomTransitions.gd")  # TODO: handle transitions more elegantly
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)
	
	########################
	## DIALOGIC
	########################
	EventHub.interactive_dialogue_started.connect(_on_dialogue_started)
	EventHub.interactive_dialogue_ended.connect(_on_dialogue_ended)
	
	########################
	## DIALOGIC + GAME_STATE
	########################
	EventHub.game_paused.connect(Dialogic.set.bind("paused", true))
	EventHub.game_unpaused.connect(Dialogic.set.bind("paused", false))

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
	if "on_enter" in player:
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

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if game_state == GAME_STATES.PAUSE:
			EventHub.game_unpaused.emit()
		else:
			EventHub.game_paused.emit()

func _on_death():
	get_tree().change_scene_to_file.call_deferred("res://game/menus/main_menu.tscn")

func _on_dialogue_started():
	game_state = GAME_STATES.DIALOGUE

func _on_dialogue_ended():
	game_state = GAME_STATES.GAME

func _pause_game():
	previous_game_state = game_state
	game_state = GAME_STATES.PAUSE

func _unpause_game():
	game_state = previous_game_state
