extends CharacterBody2D

@export var speed: float = 180.0

var heart_rate: float = 100.0
var heart_max: float = 100.0
var heart_decay: float = 5.0
var adrenaline_gain: float = 18.0

var is_dead := false

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

func decrease_heart(delta: float) -> void:
	heart_rate -= heart_decay * delta
	heart_rate = clamp(heart_rate, 0, heart_max)

func increase_heart(delta: float) -> void:
	heart_rate += adrenaline_gain * delta
	heart_rate = clamp(heart_rate, 0, heart_max)

func die() -> void:
	is_dead = true
	print("GAME OVER")
