extends CanvasLayer

@onready var title_label: Label = $Label 

func _ready() -> void:
	# 1. Create a fresh animation controller (Tween)
	var tween = create_tween()
	
	# 2. Tell the tween to fade the transparency (modulate:a) to 1.0 (fully visible) over 1.5 seconds
	tween.tween_property(title_label, "modulate:a", 1.0, 1.5)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/patio.tscn")
