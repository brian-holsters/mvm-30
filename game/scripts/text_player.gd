extends Node
class_name TextPlayerNode

signal timeline_started
signal timeline_ended

const AUTO_PROGRESS := "auto"
const INPUT_PROGRESS := "input"

@export var timeline: String
@export_enum(AUTO_PROGRESS, INPUT_PROGRESS) var mode: String = AUTO_PROGRESS

var playing := false

func _ready() -> void:
	tree_exited.connect(_on_tree_exited)

func play_timeline():
	playing = true
	match mode:
		AUTO_PROGRESS:
			Dialogic.Inputs.auto_advance.enabled_forced = true
		INPUT_PROGRESS:
			EventHub.interactive_dialogue_started.emit()
			Dialogic.Inputs.auto_advance.enabled_forced = false
	
	if Dialogic.current_timeline != null:
		await Dialogic.end_timeline(true)
	Dialogic.start(timeline)
	timeline_started.emit()
	await Dialogic.timeline_ended
	timeline_ended.emit()
	if mode == INPUT_PROGRESS:
		EventHub.interactive_dialogue_ended.emit()

func _on_tree_exited():
	if playing and mode == INPUT_PROGRESS:
		EventHub.interactive_dialogue_ended.emit()
