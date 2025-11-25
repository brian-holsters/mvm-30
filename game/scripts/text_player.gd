extends Node

signal timeline_started
signal timeline_ended

@export var timeline: String

func play_timeline():
	if Dialogic.current_timeline != null:
		await Dialogic.end_timeline(true)
	Dialogic.start(timeline)
	timeline_started.emit()
	await Dialogic.timeline_ended
	timeline_ended.emit()
