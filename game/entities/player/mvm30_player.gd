extends PlayerCharacterBody2D
class_name MvmPlayer

signal died
signal hp_changed

const DEFAULT_MAX_HP := 5

var max_hp := 5
var hp := 5:
	set(val):
		hp = clamp(val, 0, max_hp)
		if hp == 0:
			died.emit()
		hp_changed.emit()

func on_room_loaded():
	print("player:")
	print(global_position)
	save_data()

func save_data():
	Game.save_manager.data["player"] = _serialize_data()

func load_data():
	var player_data = Game.save_manager.data.get("player", {})
	max_hp = player_data.get("max_hp", DEFAULT_MAX_HP)
	hp = player_data.get("hp", DEFAULT_MAX_HP)
	var upgrade_data = Game.save_manager.data.get("upgrades", {})
	for upgrade in upgrade_data.keys():
		if upgrade_data[upgrade]:
			unlock_ability(upgrade)

func unlock_ability(ability_name: String):
	var ability_state := state_machine.states[ability_name]
	if ability_state:
		ability_state.is_available = true

func increase_max_hp(amount: int):
	max_hp += amount
	hp += amount

func take_damage(amount: int):
	hp -= amount

func full_heal():
	hp = max_hp


func _serialize_data():
	return {
		"max_hp": max_hp,
		#"hp": hp
	}


func _on_animated_sprite_2d_frame_changed() -> void:
	pass # Replace with function body.
