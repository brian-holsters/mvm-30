extends Area2D
class_name DangerDetector2D

@export var filter_group: String = "enemies"
@onready var detector_shape = $CollisionShape2D

var boss: bool = false

func _on_ready():
	detector_shape.shape.radius = AudioController.MAX_ENEMY_DISTANCE
	
func  _physics_process(_delta: float) -> void:
	var distance = get_closest_distance()
	#print("distance: "+str(distance))
	AudioController.set_enemy_distance(distance)

func get_closest_distance() -> float:
	var closest := INF
	var bodies := get_overlapping_areas()
	#print(bodies)
	for body in bodies:
		#print("body: "+str(body))
		if body is DangerZone2D:
			var d = global_position.distance_to(body.global_position)
			if d < closest:
				closest = d
			#print(closest)
	return closest
