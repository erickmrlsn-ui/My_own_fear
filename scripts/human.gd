extends CharacterBody2D

signal collapsed

@export var flee_speed: float = 150.0
@export var fear_radius: float = 260.0
@export var collapse_radius: float = 22.0
@export var wall_check_distance: float = 32.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var shadow: CharacterBody2D
var is_collapsed := false
var can_move := true


func _ready() -> void:
	anim.play("idle")


func _physics_process(_delta: float) -> void:
	if shadow == null or is_collapsed or not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		update_animation()
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
	update_animation()


func flee_from_shadow() -> void:
	var away_direction := shadow.global_position.direction_to(global_position).normalized()
	var best_direction := get_best_escape_direction(away_direction)

	velocity = best_direction * flee_speed


func get_best_escape_direction(base_direction: Vector2) -> Vector2:
	var possible_directions := [
		base_direction,
		base_direction.rotated(deg_to_rad(35)),
		base_direction.rotated(deg_to_rad(-35)),
		base_direction.rotated(deg_to_rad(70)),
		base_direction.rotated(deg_to_rad(-70)),
		base_direction.rotated(deg_to_rad(110)),
		base_direction.rotated(deg_to_rad(-110))
	]

	for direction in possible_directions:
		if not test_move(global_transform, direction.normalized() * wall_check_distance):
			return direction.normalized()

	return base_direction


func update_animation() -> void:
	if velocity.length() > 5:
		if anim.animation != "walk":
			anim.play("walk")

		if velocity.x < -1:
			anim.flip_h = true
		elif velocity.x > 1:
			anim.flip_h = false
	else:
		if anim.animation != "idle":
			anim.play("idle")


func collapse() -> void:
	is_collapsed = true
	velocity = Vector2.ZERO
	anim.play("idle")
	print("GAME OVER: el humano colapsó")
	collapsed.emit()
