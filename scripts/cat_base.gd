class_name Cat
extends CharacterBody2D

enum State { WANDER, SATISFIED }

const SPEED = 120.0
const HAPPINESS_RISE_RATE = 20.0
const HAPPINESS_DECAY_RATE = 10.0

@export var happiness_bar_path: NodePath
var happiness_bar: ProgressBar
var wander_target: Vector2
var happiness: float = 50.0
var state: State = State.WANDER

func _ready() -> void:
	happiness_bar = get_node(happiness_bar_path)
	wander_target = global_position

func _physics_process(delta: float) -> void:
	var should_be_satisfied = check_satisfied()

	if should_be_satisfied and state != State.SATISFIED:
		_change_state(State.SATISFIED)
	elif not should_be_satisfied and state != State.WANDER:
		_change_state(State.WANDER)

	match state:
		State.WANDER:
			_process_wander(delta)
		State.SATISFIED:
			_process_satisfied(delta)

	happiness = clamp(happiness, 0.0, 100.0)
	happiness_bar.value = happiness

	move_and_slide()

func _change_state(new_state: State) -> void:
	state = new_state

func _process_wander(delta: float) -> void:
	var distance_to_wander_target = global_position.distance_to(wander_target)
	if distance_to_wander_target < 5.0:
		velocity = Vector2.ZERO
	else:
		var direction = (wander_target - global_position).normalized()
		velocity = direction * (SPEED * 0.5)
	happiness -= HAPPINESS_DECAY_RATE * delta

func _process_satisfied(delta: float) -> void:
	velocity = get_satisfied_direction() * SPEED
	happiness += HAPPINESS_RISE_RATE * delta

func _on_timer_timeout() -> void:
	var random_offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	wander_target = global_position + random_offset

# Override in each subclass: return true when this cat's specific
# happy condition is met.
func check_satisfied() -> bool:
	return false

# Override in each subclass: return the direction to move while satisfied.
func get_satisfied_direction() -> Vector2:
	return Vector2.ZERO
