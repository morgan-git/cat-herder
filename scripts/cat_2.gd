extends Cat

const DETECTION_RADIUS = 250.0

@export var yarn_ball_path: NodePath
var yarn_ball: Node2D

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)
	super._ready()

func check_satisfied() -> bool:
	return global_position.distance_to(yarn_ball.global_position) > DETECTION_RADIUS

func get_satisfied_direction() -> Vector2:
	return (global_position - yarn_ball.global_position).normalized()
