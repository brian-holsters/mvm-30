extends PlayerCharacterBody2D
class_name MvmPlayer

func on_enter():
	$Camera2D.reset_smoothing()

func unlock_ability(ability_name: String):
	var ability_state := state_machine.states[ability_name]
	if ability_state:
		ability_state.is_available = true
