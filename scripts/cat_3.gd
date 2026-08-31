extends CharacterBody2D

const SPEED = 120.0

@export var table_marker_path: NodePath
var table_marker: Node2D

func _ready() -> void:
	table_marker = get_node(table_marker_path)

func _physics_process(delta: float) -> void:
	var distance_to_marker = global_position.distance_to(table_marker.global_position)

	if distance_to_marker < 5.0:
		velocity = Vector2.ZERO
	else:
		var direction = (table_marker.global_position - global_position).normalized()
		velocity = direction * SPEED

	move_and_slide()
