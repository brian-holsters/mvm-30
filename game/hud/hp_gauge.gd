extends GridContainer

var template: Control

var player: MvmPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	template = get_child(0)
	remove_child(template)

func update():
	for child in get_children():
		child.queue_free()
	for i in range(player.hp):
		var hp_block = template.duplicate()
		add_child(hp_block)
