extends Node2D

@export var game_timer_path: NodePath
@export var countdown_label_path: NodePath
@export var result_label_path: NodePath
@export var cat1_path: NodePath
@export var cat2_path: NodePath
@export var cat3_path: NodePath

const HAPPINESS_THRESHOLD = 60.0

var game_timer: Timer
var countdown_label: Label
var result_label: Label
var cat1: Node
var cat2: Node
var cat3: Node

func _ready() -> void:
	game_timer = get_node(game_timer_path)
	countdown_label = get_node(countdown_label_path)
	result_label = get_node(result_label_path)
	cat1 = get_node(cat1_path)
	cat2 = get_node(cat2_path)
	cat3 = get_node(cat3_path)
	result_label.visible = false

func _process(delta: float) -> void:
	countdown_label.text = str(int(ceil(game_timer.time_left)))
	if game_timer.time_left <= 5.0:
		countdown_label.add_theme_color_override("font_color", Color.RED)
	else:
		countdown_label.add_theme_color_override("font_color", Color.WHITE) # Or your default color
	if cat1.happiness >= 100.0 and cat2.happiness >= 100.0 and cat3.happiness >= 100.0:
		_end_game(true)

func _end_game(won: bool) -> void:
	game_timer.stop()
	GameEffects.stop_all_sounds()
	if won:
		result_label.text = "You did it! All three cats are happy."
	else:
		result_label.text = "Try again, someone's not happy."
	result_label.visible = true
	get_tree().paused = true

	
func _unhandled_input(event: InputEvent) -> void:
	if result_label.visible and event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	var all_happy = cat1.happiness >= HAPPINESS_THRESHOLD \
		and cat2.happiness >= HAPPINESS_THRESHOLD \
		and cat3.happiness >= HAPPINESS_THRESHOLD
	_end_game(all_happy)
