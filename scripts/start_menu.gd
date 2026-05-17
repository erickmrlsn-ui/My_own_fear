extends Control

@onready var play_button: Button = $PlayButton
@onready var fade_rect: ColorRect = $FadeRect
@onready var button_hover_effect: ColorRect = $ButtonHoverEffect

var hover_tween: Tween


func _ready() -> void:
	fade_rect.color = Color(0, 0, 0, 0)

	play_button.pressed.connect(_on_play_pressed)
	play_button.mouse_entered.connect(_on_play_hover_entered)
	play_button.mouse_exited.connect(_on_play_hover_exited)

	_set_hover_strength(0.25)


func _on_play_pressed() -> void:
	play_button.disabled = true

	var tween := create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
	tween.finished.connect(_go_to_game)


func _go_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/IntroVideo.tscn")


func _on_play_hover_entered() -> void:
	_tween_hover_strength(1.0)


func _on_play_hover_exited() -> void:
	_tween_hover_strength(0.0)


func _tween_hover_strength(value: float) -> void:
	if hover_tween:
		hover_tween.kill()

	hover_tween = create_tween()
	hover_tween.tween_method(_set_hover_strength, _get_hover_strength(), value, 0.25)


func _set_hover_strength(value: float) -> void:
	var mat := button_hover_effect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("hover_strength", value)


func _get_hover_strength() -> float:
	var mat := button_hover_effect.material as ShaderMaterial
	if mat:
		return mat.get_shader_parameter("hover_strength")
	return 0.0
