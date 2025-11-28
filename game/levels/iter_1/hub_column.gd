extends Area2D

signal area_triggered
@export var fireOnce:bool
@export var isActive:bool = false

func _ready():
	pass # Replace with function body.

func _process(delta: float) -> void:
	if isActive and get_overlapping_bodies().size()>0:
		emit_signal("area_triggered")
		isActive=!fireOnce

func saveState():
	var save_dict:Dictionary = {
		"name": name,
		"path": get_path(),
		"fireOnce": fireOnce,
		"isActive": isActive,
	}
	return save_dict

func loadState(dict:Dictionary):
	if dict.get("fireOnce")!=null: fireOnce=dict.get("fireOnce")
	if dict.get("isActive")!=null: isActive=dict.get("isActive")




func _on_enemy_was_defeated(enemy):
	pass # Replace with function body.

func set_isActive(value=true):
	isActive=value
