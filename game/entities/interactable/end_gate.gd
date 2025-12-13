extends Terminal

@onready var escape_flag_node: FlagNode = $EscapeFlagNode
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fake_player: AnimatedSprite2D = %FakePlayer
@onready var player_goal_position: Marker2D = %PlayerGoalPosition

signal _player_reached_goal

const MOVEMENT_SPEED = 1.5

var player_moving := false

func _ready() -> void:
	super()
	deactivate()
	fake_player.hide()
	animation_player.play("closed")

func _process(delta: float) -> void:
	if not player_moving:
		return
	
	fake_player.global_position = fake_player.global_position.move_toward(
		player_goal_position.global_position, 
		MOVEMENT_SPEED
	)
	
	if fake_player.global_position.is_equal_approx(player_goal_position.global_position):
		player_moving = false
		_player_reached_goal.emit()

func _on_terminal_interact():
	super()
	get_tree().call_group("count_down", "queue_free")
	# hide and deactivate real player
	Game.singleton.player.hide()
	Game.singleton.player.process_mode = Node.PROCESS_MODE_DISABLED
	# introduce fake player and move to center
	fake_player.global_position = MetSys.exact_player_position
	fake_player.show()
	player_moving = true
	await _player_reached_goal
	animation_player.play("closing")
	await animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	EventHub.game_end.emit()


func activate():
	if not is_node_ready():
		await ready
	super()
	animation_player.play("open")
