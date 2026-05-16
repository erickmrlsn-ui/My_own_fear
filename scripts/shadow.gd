extends CharacterBody2D

@export var speed: float = 130.0

var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var direction := global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider() == player:
			player.die()
