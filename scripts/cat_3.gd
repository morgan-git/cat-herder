# cat_3.gd
extends Cat

@export var table_marker_path: NodePath
var table_marker: Node2D

func _ready() -> void:
	table_marker = get_node(table_marker_path)
	super._ready()

func check_satisfied() -> bool:
	return true

func get_satisfied_direction() -> Vector2:
	return (table_marker.global_position - global_position).normalized()
