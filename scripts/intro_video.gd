extends Control

@onready var video_player: VideoStreamPlayer = $VideoPlayer
@onready var fade_rect: ColorRect = $FadeRect

var changing_scene := false
var can_skip := false


func _ready() -> void:
	fade_rect.color = Color(0, 0, 0, 1)

	video_player.finished.connect(_on_video_finished)
	video_player.play()

	var tween := create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.8)

	await get_tree().create_timer(1.0).timeout
	can_skip = true


func _process(_delta: float) -> void:
	if can_skip and not changing_scene and Input.is_key_pressed(KEY_SPACE):
		_go_to_game()


func _on_video_finished() -> void:
	_go_to_game()


func _go_to_game() -> void:
	if changing_scene:
		return

	changing_scene = true
	can_skip = false

	var tween := create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 0.8)
	tween.finished.connect(_change_to_game)


func _change_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
