@tool
extends OneShotState

@export var grounded_state: CharacterControllerState
@export var airborne_state: CharacterControllerState

func _change_state(_to: StringName, data: Dictionary[String, Variant]):
	if actor.is_on_floor():
		super(grounded_state.name, data)
	else:
		super(airborne_state.name, data)
