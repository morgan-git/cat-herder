extends Cat

const CURIOUS_RADIUS = 200.0
const SPOOK_DURATION = 1.5
const ARRIVE_ENTER = 45.0
const ARRIVE_EXIT = 60.0

var spook_timer: float = 0.0
var has_arrived: bool = false

func _ready() -> void:
	for ball in get_tree().get_nodes_in_group("yarn"):
		ball.moved.connect(_on_yarn_moved.bind(ball))
	super._ready()

func _on_yarn_moved(ball: Node2D) -> void:
	var distance = global_position.distance_to(ball.global_position)
	if distance <= CURIOUS_RADIUS:
		spook_timer = SPOOK_DURATION

func check_satisfied() -> bool:
	if spook_timer > 0.0:
		return false
	var yarn_ball = _get_nearest_yarn_ball()
	if yarn_ball == null:
		return false
	_update_arrival(yarn_ball)
	return has_arrived

func _update_arrival(yarn_ball: Node2D) -> void:
	var distance = global_position.distance_to(yarn_ball.global_position)
	if has_arrived:
		has_arrived = distance < ARRIVE_EXIT
	else:
		has_arrived = distance < ARRIVE_ENTER

func _process_wander(delta: float) -> void:
	var yarn_ball = _get_nearest_yarn_ball()

	if spook_timer > 0.0:
		spook_timer -= delta
		if yarn_ball != null:
			var flee_direction = (global_position - yarn_ball.global_position).normalized()
			velocity = flee_direction * SPEED
			_play_directional_animation(flee_direction, "Running")
		else:
			velocity = Vector2.ZERO
			_play_animation("Idle")
	elif yarn_ball != null and global_position.distance_to(yarn_ball.global_position) <= CURIOUS_RADIUS:
		var approach_direction = (yarn_ball.global_position - global_position).normalized()
		velocity = approach_direction * (SPEED * 0.4)
		_play_directional_animation(approach_direction, "Walk")
	else:
		velocity = Vector2.ZERO
		_play_animation("Idle")

	happiness -= HAPPINESS_DECAY_RATE * delta

func get_satisfied_direction() -> Vector2:
	return Vector2.ZERO

func get_satisfied_animation() -> String:
	return "Sit"
