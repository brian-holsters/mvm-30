extends Node
class_name SpawnSetter

func set_spawn_to_current_room():
	var room = MetSys.get_current_room_id()
	Game.save_manager.data["spawn_room"] = room
