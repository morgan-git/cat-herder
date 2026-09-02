extends CharacterBody2D

const SPEED = 200.0

@export var yarn_ball_path: NodePath
@export var animated_sprite_path: NodePath
var yarn_ball: Node2D
var animated_sprite: AnimatedSprite2D

func _ready() -> void:
	yarn_ball = get_node(yarn_ball_path)
	animated_sprite = get_node(animated_sprite_path)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

	_update_animation(direction)

	if Input.is_action_just_pressed("ui_accept"):
		yarn_ball.global_position = global_position

func _update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		_play_animation("Idle")
		return

	# Vertical movement takes priority when it's the stronger component,
	# so diagonal movement still picks a sensible facing animation.
	if abs(direction.y) > abs(direction.x):
		if direction.y < 0:
			_play_animation("WalkUp")
		else:
			_play_animation("WalkDown")
	else:
		_play_animation("Walk")
		animated_sprite.flip_h = direction.x < 0

func _play_animation(anim_name: String) -> void:
	if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
		animated_sprite.play(anim_name)
