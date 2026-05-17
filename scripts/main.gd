extends Node2D

@onready var shadow: CharacterBody2D = $Shadow
@onready var human: CharacterBody2D = $Human
@onready var monitors_node: Node2D = $Monitors

@onready var monitor_label: Label = $UI/MonitorLabel
@onready var message_label: Label = $UI/MessageLabel

@onready var game_camera: Camera2D = $GameCamera

var activated_monitors := 0
var game_finished := false


func _ready() -> void:
	place_objects_from_level()

	human.shadow = shadow
	human.collapsed.connect(_on_human_collapsed)

	for monitor in monitors_node.get_children():
		if monitor.has_signal("activated"):
			monitor.activated.connect(_on_monitor_activated)

	update_ui()
	message_label.text = "Guía al humano hacia los 3 monitores"

	game_camera.enabled = true
	update_camera()


func _process(_delta: float) -> void:
	update_camera()

	if game_finished and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

	if not game_finished and Input.is_action_just_pressed("debug_activate_monitor"):
		debug_activate_monitor()

	if not game_finished and Input.is_action_just_pressed("debug_win"):
		win_game()

func place_objects_from_level() -> void:
	if not has_node("LevelMain"):
		print("No existe LevelMain")
		return

	var level = $LevelMain

	if level.has_node("ShadowSpawn"):
		shadow.global_position = level.get_node("ShadowSpawn").global_position
		print("Shadow position: ", shadow.global_position)

	if level.has_node("PlayerSpawn"):
		human.global_position = level.get_node("PlayerSpawn").global_position
		print("Human position: ", human.global_position)

	if level.has_node("Monitor1"):
		$Monitors/Monitor1.global_position = level.get_node("Monitor1").global_position

	if level.has_node("Monitor2"):
		$Monitors/Monitor2.global_position = level.get_node("Monitor2").global_position

	if level.has_node("Monitor3"):
		$Monitors/Monitor3.global_position = level.get_node("Monitor3").global_position


func _on_monitor_activated() -> void:
	if game_finished:
		return

	activated_monitors += 1
	update_ui()

	print("Monitores activados: ", activated_monitors, "/3")

	if activated_monitors >= 3:
		win_game()


func _on_human_collapsed() -> void:
	if game_finished:
		return

	game_finished = true

	shadow.can_move = false
	human.can_move = false

	message_label.text = "PERDISTE - Presiona R para reiniciar"
	print("PERDISTE: el humano colapsó")


func win_game() -> void:
	if game_finished:
		return

	game_finished = true

	shadow.can_move = false
	human.can_move = false

	message_label.text = "VICTORIA - Despertando..."
	print("VICTORIA: activaste los 3 monitores")

	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/OutroVideo.tscn")

func update_ui() -> void:
	monitor_label.text = "Monitores: " + str(activated_monitors) + "/3"

func update_camera() -> void:
	game_camera.global_position = shadow.global_position
	game_camera.zoom = Vector2(0.65, 0.65)
func debug_activate_monitor() -> void:
	if activated_monitors >= 3:
		return

	activated_monitors += 1
	update_ui()

	print("DEBUG: monitor activado manualmente: ", activated_monitors, "/3")

	if activated_monitors >= 3:
		win_game()
