@tool
extends CharacterControllerState

@export var health_component: Node
@export var return_to_state: CharacterControllerState

var tween: Tween


func enter(_from: StringName, data: Dictionary[String, Variant]) -> void:
	var damage = data["damage"]
	var stun_time = data["stun_time"]
	var origin_position = data["origin_position"]
	health_component.hp -= damage
	if tween and tween.is_running():
		tween.stop()
		tween.finished.disconnect(_on_tween_finished)
	var knockback = 20
	var hit_direction = sign(actor.global_position.x - origin_position.x)
	var target_progress = actor.progress + (knockback * hit_direction)
	
	tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(actor, "progress", target_progress, stun_time)

func _on_tween_finished():
	if not is_active:
		return
	state_machine.request_state_change(return_to_state.name)
