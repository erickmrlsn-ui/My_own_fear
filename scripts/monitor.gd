extends Area2D

signal activated

@export var off_texture: Texture2D
@export var on_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var indicator: CanvasItem = $Indicator

var is_activated := false
var pulse_time := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if off_texture != null:
		sprite.texture = off_texture


func _process(delta: float) -> void:
	if is_activated:
		return

	pulse_time += delta

	var float_offset := sin(pulse_time * 4.0) * 8.0
	var pulse_scale := 1.0 + sin(pulse_time * 5.0) * 0.15

	indicator.position.y = -80 + float_offset
	indicator.scale = Vector2(pulse_scale, pulse_scale)


func _on_body_entered(body: Node2D) -> void:
	if is_activated:
		return

	if body.name == "Human":
		is_activated = true

		if on_texture != null:
			sprite.texture = on_texture

		indicator.visible = false

		print(name, " activado")
		activated.emit()
