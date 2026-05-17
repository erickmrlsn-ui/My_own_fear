extends Node2D

@onready var shadow = $Shadow
@onready var human = $Human
@onready var monitors = $Monitors.get_children()

var activated_monitors := 0
var game_finished := false

func _ready() -> void:
	human.shadow = shadow
	human.collapsed.connect(_on_human_collapsed)

	for monitor in monitors:
		monitor.activated.connect(_on_monitor_activated)

func _on_monitor_activated() -> void:
	if game_finished:
		return

	activated_monitors += 1
	print("Monitores activados: ", activated_monitors, "/3")

	if activated_monitors >= 3:
		win_game()

func _on_human_collapsed() -> void:
	if game_finished:
		return

	game_finished = true
	print("PERDISTE: el humano colapsó")

func win_game() -> void:
	game_finished = true
	print("VICTORIA: activaste los 3 monitores")
