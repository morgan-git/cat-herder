extends CharacterBody2D

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
	happiness_bar = get_node(happiness_bar_path)
	wander_target = global_position

func _physics_process(delta: float) -> void:
	var distance_to_toy = global_position.distance_to(yarn_ball.global_position)
	var is_satisfied = distance_to_toy > DETECTION_RADIUS
	if is_satisfied:
		
		happiness += HAPPINESS_RISE_RATE * delta
	else:
		happiness -= HAPPINESS_DECAY_RATE * delta
		
	if distance_to_toy <= DETECTION_RADIUS:
		var direction = (global_position - yarn_ball.global_position).normalized()
		velocity = direction * SPEED
	else:
		var distance_to_wander_target = global_position.distance_to(wander_target)
		if distance_to_wander_target < 5.0:
			velocity = Vector2.ZERO
		else:
			var direction = (wander_target - global_position).normalized()
			velocity = direction * (SPEED * 0.5)
	
	happiness = clamp(happiness, 0.0, 100.0)
	happiness_bar.value = happiness
	move_and_slide()


func _on_timer_timeout() -> void:

	var random_offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	wander_target = global_position + random_offset
