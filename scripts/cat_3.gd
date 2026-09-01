extends Cat

const ARRIVE_THRESHOLD = 45.0

@export var table_marker_path: NodePath
var table_marker: Node2D

func _ready() -> void:
	table_marker = get_node(table_marker_path)
	super._ready()

func check_satisfied() -> bool:
	return true

func get_satisfied_direction() -> Vector2:
	if global_position.distance_to(table_marker.global_position) < ARRIVE_THRESHOLD:
		return Vector2.ZERO
	return (table_marker.global_position - global_position).normalized()

func get_satisfied_animation() -> String:
	if global_position.distance_to(table_marker.global_position) < ARRIVE_THRESHOLD:
		return "Sit"
	return "Walk"
