extends Node

# Preload the shared sound files once, globally. Both point at the same
# file for now since only one sound exists yet, update ACCIDENT_SOUND
# once a separate file is available.
const PURR_SOUND = preload("res://assets/sounds/catpurring.mp3")
const ACCIDENT_SOUND = preload("res://assets/sounds/catpurring.mp3")
const PUDDLE_SCENE = preload("res://scenes/puddle.tscn")

var _active_players: Array[AudioStreamPlayer2D] = []
var active_puddle_count: int = 0

func play_purr(at_position: Vector2) -> void:
	_play_sound(PURR_SOUND, at_position)

func play_accident(at_position: Vector2) -> void:
	_play_sound(ACCIDENT_SOUND, at_position)

func spawn_puddle(at_position: Vector2, parent: Node) -> void:
	var puddle = PUDDLE_SCENE.instantiate()
	parent.add_child(puddle)
	puddle.global_position = at_position
	active_puddle_count += 1
	puddle.tree_exiting.connect(_on_puddle_removed)

func _on_puddle_removed() -> void:
	active_puddle_count -= 1

func has_active_puddles() -> bool:
	return active_puddle_count > 0

# Stops and removes every currently playing sound immediately. Call this
# when the game round ends so nothing keeps playing over a paused scene.
func stop_all_sounds() -> void:
	for player in _active_players:
		if is_instance_valid(player):
			player.stop()
			player.queue_free()
	_active_players.clear()

# Creates a temporary, throwaway AudioStreamPlayer2D for one sound, then
# frees itself when done. This lets multiple cats play the same sound at
# the same time without needing their own dedicated player node.
func _play_sound(stream: AudioStream, at_position: Vector2) -> void:
	var player = AudioStreamPlayer2D.new()
	player.stream = stream
	player.global_position = at_position
	get_tree().current_scene.add_child(player)
	player.play()
	_active_players.append(player)
	player.finished.connect(func():
		_active_players.erase(player)
		player.queue_free()
	)
