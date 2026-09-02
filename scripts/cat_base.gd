class_name Cat
extends CharacterBody2D

enum State { WANDER, SATISFIED }

const SPEED = 120.0
const HAPPINESS_RISE_RATE = 20.0
const HAPPINESS_DECAY_RATE = 10.0

@export var happiness_bar_path: NodePath
@export var animated_sprite_path: NodePath
var happiness_bar: ProgressBar
var animated_sprite: AnimatedSprite2D
var wander_target: Vector2
var happiness: float = 50.0
var state: State = State.WANDER

func _ready() -> void:
	happiness_bar = get_node(happiness_bar_path)
	animated_sprite = get_node(animated_sprite_path)
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
	_check_happiness_events(delta)

	move_and_slide()

func _change_state(new_state: State) -> void:
	print(name, " changing state to: ", State.keys()[new_state], " at time: ", Time.get_ticks_msec())
	state = new_state

func _process_wander(delta: float) -> void:
	var distance_to_wander_target = global_position.distance_to(wander_target)
	if distance_to_wander_target < 5.0:
		velocity = Vector2.ZERO
		_play_animation("Idle")
	else:
		var direction = (wander_target - global_position).normalized()
		velocity = direction * (SPEED * 0.5)
		_play_directional_animation(direction, "Walk")
	happiness -= HAPPINESS_DECAY_RATE * delta

func _process_satisfied(delta: float) -> void:
	var direction = get_satisfied_direction()
	velocity = direction * SPEED
	_play_directional_animation(direction, get_satisfied_animation())
	happiness += HAPPINESS_RISE_RATE * delta

# Picks a directional animation variant based on movement direction.
# Vertical movement (Up/Down suffix) takes priority when it's the
# stronger component, otherwise plays the plain base animation and
# flips it left/right to match horizontal movement.
func _play_directional_animation(direction: Vector2, base_name: String) -> void:
	if direction == Vector2.ZERO:
		_play_animation(base_name)
		return

	if abs(direction.y) > abs(direction.x):
		if direction.y < 0:
			_play_animation(base_name + "Up")
		else:
			_play_animation(base_name + "Down")
	else:
		_play_animation(base_name)
		animated_sprite.flip_h = direction.x > 0

func _play_animation(anim_name: String) -> void:
	if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
		animated_sprite.play(anim_name)

const PURR_THRESHOLD = 80.0
const LOW_HAPPINESS_THRESHOLD = 20.0
const LOW_HAPPINESS_ACCIDENT_TIME = 5.0

var has_purred: bool = false
var has_had_accident: bool = false
var low_happiness_timer: float = 0.0

func _on_timer_timeout() -> void:
	var random_offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	wander_target = global_position + random_offset

func _check_happiness_events(delta: float) -> void:
	if happiness >= PURR_THRESHOLD and not has_purred:
		GameEffects.play_purr(global_position)
		has_purred = true
	elif happiness < PURR_THRESHOLD:
		has_purred = false

	if happiness < LOW_HAPPINESS_THRESHOLD:
		low_happiness_timer += delta
		if low_happiness_timer >= LOW_HAPPINESS_ACCIDENT_TIME and not has_had_accident:
			GameEffects.play_accident(global_position)
			GameEffects.spawn_puddle(global_position, get_parent())
			has_had_accident = true
	else:
		low_happiness_timer = 0.0
		has_had_accident = false

# Override in each subclass: return true when this cat's specific
# happy condition is met.
func check_satisfied() -> bool:
	return false

# Override in each subclass: return the direction to move while satisfied.
func get_satisfied_direction() -> Vector2:
	return Vector2.ZERO

# Override in each subclass: return the animation name to play while satisfied.
func get_satisfied_animation() -> String:
	return "Running"
