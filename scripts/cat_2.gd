extends Cat

const DETECTION_ENTER = 50.0
const DETECTION_EXIT = 70.0
const CENTER_BIAS = 0.5

@export var patio_center: Vector2

func check_satisfied() -> bool:
	var yarn_ball = _get_nearest_yarn_ball()
	if yarn_ball == null:
		return true
	var distance = global_position.distance_to(yarn_ball.global_position)
	if state == State.SATISFIED:
		return distance > DETECTION_ENTER
	else:
		return distance > DETECTION_EXIT

# Satisfied for Cat2 means no yarn ball is close: calm, passive wandering,
# happiness rises.
func _process_satisfied(delta: float) -> void:
	var distance_to_wander_target = global_position.distance_to(wander_target)
	if distance_to_wander_target < 5.0:
		velocity = Vector2.ZERO
		_play_animation("Idle")
	else:
		var direction = (wander_target - global_position).normalized()
		velocity = direction * (SPEED * 0.5)
		_play_directional_animation(direction, "Walk")
	happiness += HAPPINESS_RISE_RATE * delta

# Not satisfied for Cat2 means the nearest yarn ball is close: flee at
# full speed, happiness falls, biased back toward patio_center.
func _process_wander(delta: float) -> void:
	var yarn_ball = _get_nearest_yarn_ball()
	if yarn_ball == null:
		velocity = Vector2.ZERO
		_play_animation("Idle")
		happiness -= HAPPINESS_DECAY_RATE * delta
		return

	var away_direction = (global_position - yarn_ball.global_position).normalized()
	var center_direction = (patio_center - global_position).normalized()
	var direction = (away_direction + center_direction * CENTER_BIAS).normalized()
	velocity = direction * SPEED
	_play_directional_animation(direction, "Running")
	happiness -= HAPPINESS_DECAY_RATE * delta
