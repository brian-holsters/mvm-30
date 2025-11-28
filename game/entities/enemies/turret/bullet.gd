extends HitBox

const MAX_LIFETIME := 15.0
var lifetime := 0.0

@export var velocity: Vector2
@export var penetration_power: int = 0
@export var phase_through_walls: bool = false

var contacts: int = 0


func _ready() -> void:
	super()
	collision_mask += 1  # Add world collision to mask for wall detection
	body_entered.connect(_on_body_entered)
	hit.connect(_on_hit.unbind(6))


func _physics_process(delta: float) -> void:
	lifetime += delta
	if lifetime > MAX_LIFETIME:
		queue_free()
		return
	position += velocity * delta


func _on_hit():
	contacts += 1
	if contacts > penetration_power:
		kill()


func _on_body_entered(body: Node):
	if "get_collision_layer_value" in body:
		if body.get_collision_layer_value(1) and not phase_through_walls:  # This is world collision
			kill()
	if (body is TileMapLayer or body is TileMap) and not phase_through_walls:
		kill()


func kill():
	# TODO: Explosion?
	queue_free()
