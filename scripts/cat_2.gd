extends Cat

const DETECTION_RADIUS = 50.0
const CENTER_BIAS = 0.5

@export var yarn_ball_path: NodePath
@export var patio_center: Vector2
var yarn_ball: Node2D

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)
	super._ready()

func check_satisfied() -> bool:
	return global_position.distance_to(yarn_ball.global_position) > DETECTION_RADIUS

# Satisfied for Cat2 means the toy is far away: calm, passive wandering,
# happiness rises. This overrides the base's default (which assumes
# satisfied means active pursuit), since Cat2's happy state is the opposite.
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

# Not satisfied for Cat2 means the toy is close: flee at full speed,
# happiness falls. Direction is biased toward patio_center so fleeing
# doesn't just drive the cat straight into whichever wall is nearest.
func _process_wander(delta: float) -> void:
	var away_direction = (global_position - yarn_ball.global_position).normalized()
	var center_direction = (patio_center - global_position).normalized()
	var direction = (away_direction + center_direction * CENTER_BIAS).normalized()
	velocity = direction * SPEED
	_play_directional_animation(direction, "Running")
	happiness -= HAPPINESS_DECAY_RATE * delta
