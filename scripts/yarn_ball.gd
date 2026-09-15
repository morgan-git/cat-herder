extends Node2D

signal moved

func place_at(new_position: Vector2) -> void:
	global_position = new_position
	moved.emit()
