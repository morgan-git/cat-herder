extends Cat

const ENTER_RADIUS = 250.0
const EXIT_RADIUS = 300.0
const ARRIVE_ENTER = 45.0
const ARRIVE_EXIT = 60.0

var has_arrived: bool = false

func check_satisfied() -> bool:
	var yarn_ball = _get_nearest_yarn_ball()
	if yarn_ball == null:
		return false
	var distance = global_position.distance_to(yarn_ball.global_position)
	if state == State.SATISFIED:
		return distance <= EXIT_RADIUS
	else:
		return distance <= ENTER_RADIUS

func get_satisfied_direction() -> Vector2:
	var yarn_ball = _get_nearest_yarn_ball()
	if yarn_ball == null:
		return Vector2.ZERO
	_update_arrival(yarn_ball)
	if has_arrived:
		return Vector2.ZERO
	return (yarn_ball.global_position - global_position).normalized()

func get_satisfied_animation() -> String:
	if has_arrived:
		return "Sit"
	return "Running"

func _update_arrival(yarn_ball: Node2D) -> void:
	var distance = global_position.distance_to(yarn_ball.global_position)
	if has_arrived:
		has_arrived = distance < ARRIVE_EXIT
	else:
		has_arrived = distance < ARRIVE_ENTER
