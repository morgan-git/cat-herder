extends Cat

const DETECTION_RADIUS = 550.0
const HAPPINESS_RADIUS = 150.0

@export var yarn_ball_path: NodePath
var yarn_ball: Node2D

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)
	super._ready()

func check_satisfied() -> bool:
	return global_position.distance_to(yarn_ball.global_position) <= HAPPINESS_RADIUS  

func get_satisfied_direction() -> Vector2:
	return (yarn_ball.global_position - global_position).normalized()
