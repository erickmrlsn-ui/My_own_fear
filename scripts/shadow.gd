extends CharacterBody2D

@export var speed: float = 180.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var can_move := true


func _ready() -> void:
	anim.play("idle")


func _physics_process(_delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		update_animation()
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	update_animation()


func update_animation() -> void:
	if velocity.length() > 5:
		if anim.animation != "walk":
			anim.play("walk")

		if velocity.x < -1:
			anim.flip_h = false
		elif velocity.x > 1:
			anim.flip_h = true
			
	else:
		if anim.animation != "idle":
			anim.play("idle")
