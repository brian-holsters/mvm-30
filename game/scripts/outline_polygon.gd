@tool
extends Polygon2D

var line: Line2D
@export_tool_button("Update outline") var x = update_line

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_line()

func create_line():
	line = Line2D.new()
	line.name = "Outline2D"
	add_child(line)
	line.owner = get_tree().edited_scene_root
	return line

func find_line():
	for child in get_children():
		if child is Line2D:
			line = child
			return true
	return false

func update_line() -> void:
	if not find_line():
		create_line()
	line.closed = true
	line.points = polygon
