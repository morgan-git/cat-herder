extends Cat

const ARRIVE_ENTER = 45.0
const ARRIVE_EXIT = 60.0

@export var table_marker_path: NodePath
var table_marker: Node2D
var has_arrived: bool = false

func _ready() -> void:
	table_marker = get_node(table_marker_path)
	super._ready()

func _update_arrival() -> void:
	var distance = global_position.distance_to(table_marker.global_position)
	if has_arrived:
		has_arrived = distance < ARRIVE_EXIT
	else:
		has_arrived = distance < ARRIVE_ENTER

func check_satisfied() -> bool:
	_update_arrival()
	return has_arrived

func get_satisfied_direction() -> Vector2:
	return Vector2.ZERO

func get_satisfied_animation() -> String:
	return "Sit"

# Cat3 always walks toward the table when not yet arrived, rather than
# the base class's random wander, since Cat3 has one single goal.
func _process_wander(delta: float) -> void:
	var direction = (table_marker.global_position - global_position).normalized()
	velocity = direction * SPEED
	_play_directional_animation(direction, "Walk")
	happiness -= HAPPINESS_DECAY_RATE * delta
