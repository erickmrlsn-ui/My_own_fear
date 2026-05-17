extends Area2D

signal activated

@onready var indicator: CanvasItem = $Indicator
@onready var sprite: Sprite2D = $Sprite2D

var is_activated := false
var pulse_time := 0.0


func _process(delta: float) -> void:
	if is_activated:
		return

	pulse_time += delta

	# Movimiento suave hacia arriba y abajo
	indicator.position.y = -80 + sin(pulse_time * 4.0) * 8.0

	# Pulso de tamaño
	var pulse_scale := 1.0 + sin(pulse_time * 5.0) * 0.15
	indicator.scale = Vector2(pulse_scale, pulse_scale)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if is_activated:
		return

	if body.name == "Human":
		is_activated = true

		# Oculta el indicador cuando el monitor ya fue activado
		indicator.visible = false

		# Feedback visual temporal: cambia el color del monitor
		sprite.modulate = Color(0.3, 1.0, 0.3)

		print(name, " activado")
		activated.emit()
