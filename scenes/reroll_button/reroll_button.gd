class_name RerollButton
extends Button

const REROLL_COST := 2

@export var player_stats: PlayerStats

@onready var h_box_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_pressed() -> void:
	player_stats.gold -= REROLL_COST


func _on_player_stats_changed() -> void:
	var has_enough_gold := player_stats.gold >= REROLL_COST
	disabled = not has_enough_gold
	
	if has_enough_gold:
		h_box_container.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		h_box_container.modulate = Color(1.0, 1.0, 1.0, 0.5)
