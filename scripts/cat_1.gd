extends Cat

const SPEED = 120.0
const DETECTION_RADIUS = 350.0
const HAPPINESS_DECAY_RATE = 20
const HAPPINESS_RISE_RATE = 10


@export var yarn_ball_path: NodePath
@export var happiness_bar_path: NodePath

var yarn_ball: Node2D
var happiness_bar: ProgressBar
var happiness: float
var wander_target: Vector2

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)
	wander_target = global_position
	happiness_bar = get_node(happiness_bar_path)

func _physics_process(delta: float) -> void:
	var distance_to_toy = global_position.distance_to(yarn_ball.global_position)
	var is_satisfied = distance_to_toy <= DETECTION_RADIUS

	if is_satisfied:
		var direction = (yarn_ball.global_position - global_position).normalized()
		velocity = direction * SPEED
		happiness += HAPPINESS_RISE_RATE * delta
	else:
		var distance_to_wander_target = global_position.distance_to(wander_target)
		if distance_to_wander_target < 5.0:
			velocity = Vector2.ZERO
		else:
			var direction = (wander_target - global_position).normalized()
			velocity = direction * (SPEED * 0.5)
		happiness -= HAPPINESS_DECAY_RATE * delta

	happiness = clamp(happiness, 0.0, 100.0)
	happiness_bar.value = happiness

	move_and_slide()


func _on_timer_timeout() -> void:

	var random_offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	wander_target = global_position + random_offset


func _on_wait_time_timeout() -> void:
	pass # Replace with function body.
