extends AnimatedSprite2D

@onready var clean_area: Area2D = $Area2D
var player_in_range: bool = false

func _ready() -> void:
	play("appear")
	clean_area.body_entered.connect(_on_body_entered)
	clean_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		clean()

# Call this later, once a cleaning mechanic exists, to make the puddle
# play its appear animation backward and remove itself when finished.
func clean() -> void:
	play_backwards("appear")
	await animation_finished
	queue_free()
