extends CharacterBody2D

const SPEED = 200.0

@export var yarn_ball_path: NodePath
var yarn_ball: Node2D

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

	if Input.is_action_just_pressed("ui_accept"):
		yarn_ball.global_position = global_position
