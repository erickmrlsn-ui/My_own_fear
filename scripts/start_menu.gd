extends Control

@onready var play_button: Button = $PlayButton
@onready var fade_rect: ColorRect = $FadeRect

func _ready() -> void:
	fade_rect.color = Color(0, 0, 0, 0)
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed() -> void:
	play_button.disabled = true

	var tween := create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
	tween.finished.connect(_go_to_story)

func _go_to_story() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
