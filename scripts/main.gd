extends Node2D

@onready var shadow = $Shadow
@onready var human = $Human
@onready var monitors = $Monitors.get_children()

@onready var monitor_label: Label = $UI/MonitorLabel
@onready var message_label: Label = $UI/MessageLabel

var activated_monitors := 0
var game_finished := false

func _ready() -> void:
	human.shadow = shadow
	human.collapsed.connect(_on_human_collapsed)

	for monitor in monitors:
		monitor.activated.connect(_on_monitor_activated)

	update_ui()
	message_label.text = "Guía al humano hacia los 3 monitores"

func _process(_delta: float) -> void:
	if game_finished and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func _on_monitor_activated() -> void:
	if game_finished:
		return

	activated_monitors += 1
	update_ui()

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
	game_finished = true
	shadow.can_move = false
	human.can_move = false
	message_label.text = "VICTORIA - Presiona R para reiniciar"
	print("VICTORIA: activaste los 3 monitores")

func update_ui() -> void:
	monitor_label.text = "Monitores: " + str(activated_monitors) + "/3"
