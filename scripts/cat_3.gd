extends CharacterBody2D

const SPEED = 120.0
const HAPPINESS_DECAY_RATE = 20
const HAPPINESS_RISE_RATE = 10
const DETECTION_RADIUS = 100.0

@export var table_marker_path: NodePath
@export var happiness_bar_path: NodePath

var table_marker: Node2D
var happiness_bar: ProgressBar
var happiness: float

func _ready() -> void:
	table_marker = get_node(table_marker_path)
	happiness_bar = get_node(happiness_bar_path)


func _physics_process(delta: float) -> void:
	var distance_to_marker = global_position.distance_to(table_marker.global_position)
	var is_satisfied = distance_to_marker <= DETECTION_RADIUS
	if is_satisfied:
		
		happiness += HAPPINESS_RISE_RATE * delta
	else:
		happiness -= HAPPINESS_DECAY_RATE * delta
	if distance_to_marker < 5.0:
		velocity = Vector2.ZERO
	else:
		var direction = (table_marker.global_position - global_position).normalized()
		velocity = direction * SPEED
	
	happiness = clamp(happiness, 0.0, 100.0)
	happiness_bar.value = happiness
	move_and_slide()
