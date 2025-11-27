extends Node

signal flag_changed(database, flag)

signal interactive_dialogue_started
signal interactive_dialogue_ended

signal game_paused
signal game_unpaused

signal request_camera_follow(target: Node2D)
signal reset_look
