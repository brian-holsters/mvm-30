extends Area2D
class_name InteractableArea2D

signal interact(interactable)

signal can_interact
signal cannot_interact

var _can_interact := false:
	set(val):
		var should_signal := val != _can_interact
		_can_interact = val
		if not should_signal:
			return
		if _can_interact:
			can_interact.emit()
		else:
			cannot_interact.emit()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _can_interact:
		interact.emit(self)


func _is_player(x: Variant) -> bool:
	print("checking if player")
	return x is MvmPlayer


func _on_body_entered(body: Node):
	print("body entered")
	if body is MvmPlayer:
		_can_interact = true
		can_interact.emit()


func _on_body_exited(_body: Node):
	print("body exited")
	if not monitoring or not get_overlapping_bodies().any(_is_player):
		_can_interact = false
		cannot_interact.emit()
