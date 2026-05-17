extends Area2D

signal activated

var is_activated := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_activated:
		return

	if body.name == "Human":
		is_activated = true
		print(name, " activado")
		activated.emit()
