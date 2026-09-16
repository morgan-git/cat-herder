extends Node2D

@export var game_timer_path: NodePath
@export var countdown_label_path: NodePath
@export var result_label_path: NodePath

const HAPPINESS_THRESHOLD = 60.0

var game_timer: Timer
var countdown_label: Label
var result_label: Label

func _ready() -> void:
	game_timer = get_node(game_timer_path)
	countdown_label = get_node(countdown_label_path)
	result_label = get_node(result_label_path)
	result_label.visible = false

	print("game_timer node: ", game_timer.name, " | wait_time: ", game_timer.wait_time, " | one_shot: ", game_timer.one_shot, " | autostart: ", game_timer.autostart)
	game_timer.timeout.connect(_on_game_timer_timeout)

func _process(delta: float) -> void:
	countdown_label.text = str(int(ceil(game_timer.time_left)))

	if _all_cats_happy(100.0) and not GameEffects.has_active_puddles():
		_end_game(true)

func _on_game_timer_timeout() -> void:
	print(">>> GAME TIMER TIMEOUT FIRED <<<")
	var cats = get_tree().get_nodes_in_group("cats")
	for cat in cats:
		print(cat.name, " happiness: ", cat.happiness)
	var won = _all_cats_happy(HAPPINESS_THRESHOLD) and not GameEffects.has_active_puddles()
	print(">>> won: ", won, " <<<")
	_end_game(won)

func _all_cats_happy(threshold: float) -> bool:
	var cats = get_tree().get_nodes_in_group("cats")
	if cats.is_empty():
		return false
	var all_happy = true
	for cat in cats:
		if cat.happiness < threshold:
			all_happy = false
	return all_happy

func _end_game(won: bool) -> void:
	print(">>> _end_game called, won: ", won, " <<<")
	game_timer.stop()
	GameEffects.stop_all_sounds()
	if won:
		result_label.text = "You did it! All the cats are happy."
	else:
		result_label.text = "Try again, someone's not happy."
	result_label.visible = true
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if result_label.visible and event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()
