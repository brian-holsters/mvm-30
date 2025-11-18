@tool
extends CharacterControllerState

var _required_exports : Array[String] = ["animated_sprite_2d", "grounded_state", "airborne_state", "variables"]
var _animation_exports: Array[String] = ["animation"]

@export var variables: MovementVariables:
	set(val):
		variables = val
		update_configuration_warnings()
@export var grounded_state: CharacterControllerState:
	set(val):
		grounded_state = val
		update_configuration_warnings()
@export var airborne_state: CharacterControllerState:
	set(val):
		airborne_state = val
		update_configuration_warnings()

@export var animated_sprite_2d: AnimatedSprite2D:
	set(val):
		animated_sprite_2d = val
		update_configuration_warnings()
@export var animation: String = "":
	set(val):
		animation = val
		update_configuration_warnings()
@export var default_knockback := Vector2(200,-100)
@export var default_stun_time := 0.75

var _knockback: Vector2
var _stun_time: float

var _execution_time: String = ""

func enter(_from: StringName, data: Dictionary[String, Variant]) -> void:
	animated_sprite_2d.play(animation)
	var looking_left_sign = 1 if actor.looking_left else -1
	var knockback = Vector2(default_knockback.x * looking_left_sign, default_knockback.y)
	_knockback = data.get("knockback", knockback)
	_stun_time = data.get("stun_time", default_stun_time)
	var damage = data.get("damage", 0)
	actor.take_damage(damage)
	actor.velocity = _knockback
	_execution_time = Time.get_datetime_string_from_system()
	var local_execution_time = _execution_time
	await get_tree().create_timer(_stun_time).timeout
	if is_active and local_execution_time == _execution_time:
		if actor.is_on_floor():
			state_machine.request_state_change(airborne_state.name)
		else:
			state_machine.request_state_change(grounded_state.name)


func physics_tick(delta: float) -> void:
	var gravity: float = variables.fall_speed / variables.time_to_fall_speed
	actor.velocity.y = move_toward(actor.velocity.y, variables.fall_speed, gravity * delta)


func exit(_to: StringName, _data: Dictionary[String, Variant]) -> void:
	_knockback = default_knockback
	_stun_time = default_stun_time


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	warnings += ConfigurationWarningHelper.collect_animation_warnings(self, _animation_exports, animated_sprite_2d.sprite_frames.get_animation_names())
	return warnings
