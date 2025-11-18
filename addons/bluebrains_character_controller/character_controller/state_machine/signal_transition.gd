@tool
extends StateTransition

signal bla

@export var listening_node: Node
@export var listening_signal: String
@export_range(0, 10) var signal_arguments: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	_required_exports += ["listening_node", "listening_signal"]
	var bound_on_signal = _on_signal
	for i in range(10-signal_arguments):
		bound_on_signal = bound_on_signal.bind("")
	listening_node.get(listening_signal).connect(bound_on_signal)


func _on_signal(_a, _b, _c, _d, _e, _f, _g, _h, _i, _j):  # 10 arguments so we can unbind until matching signal
	if not _should_run():
		return
	change_state()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = Array(super()) as Array[String]
	
	if listening_node.get(listening_signal) == null or not listening_node.get(listening_signal) is Signal:
		warnings.append("Signal ["+ listening_signal +"] not found in ["+ listening_node.name +"]")
	
	return warnings
