extends Line2D

var hitboxes: Array[HitBox]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is HitBox:
			hitboxes.append(child)
			child.monitoring = visible

func toggle():
	var status = not visible
	visible = status
	for hitbox in hitboxes:
		hitbox.monitoring = status
