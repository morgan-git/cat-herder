extends Cat

const ENTER_RADIUS = 250.0
const EXIT_RADIUS = 300.0
const ARRIVE_ENTER = 20.0
const ARRIVE_EXIT = 35.0

@export var yarn_ball_path: NodePath
var yarn_ball: Node2D
var has_arrived: bool = false

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)
	super._ready()

func check_satisfied() -> bool:
	var distance = global_position.distance_to(yarn_ball.global_position)
	if state == State.SATISFIED:
		return distance <= EXIT_RADIUS
	else:
		return distance <= ENTER_RADIUS

func _update_arrival() -> void:
	var distance = global_position.distance_to(yarn_ball.global_position)
	if has_arrived:
		has_arrived = distance < ARRIVE_EXIT
	else:
		has_arrived = distance < ARRIVE_ENTER

func get_satisfied_direction() -> Vector2:
	_update_arrival()
	if has_arrived:
		return Vector2.ZERO
	return (yarn_ball.global_position - global_position).normalized()

func get_satisfied_animation() -> String:
	if has_arrived:
		return "Sit"
	return "Running"
