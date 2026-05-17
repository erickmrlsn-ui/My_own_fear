extends CharacterBody2D

signal collapsed

@export var flee_speed: float = 120.0
@export var fear_radius: float = 220.0
@export var collapse_radius: float = 35.0

var shadow: CharacterBody2D
var is_collapsed := false

func _physics_process(delta: float) -> void:
	if shadow == null or is_collapsed:
		return

	var distance := global_position.distance_to(shadow.global_position)

	if distance <= collapse_radius:
		collapse()
		return

	if distance <= fear_radius:
		flee_from_shadow()
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func flee_from_shadow() -> void:
	var direction_away := shadow.global_position.direction_to(global_position)
	velocity = direction_away * flee_speed

func collapse() -> void:
	is_collapsed = true
	velocity = Vector2.ZERO
	print("GAME OVER: el humano colapsó")
	collapsed.emit()
