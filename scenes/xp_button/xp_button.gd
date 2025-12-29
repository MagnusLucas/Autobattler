class_name XpButton
extends Button

const XP_GAIN := 4
const COST := 4

@export var player_stats: PlayerStats
@export var buy_sound: AudioStream

@onready var v_box_container: VBoxContainer = %VBoxContainer


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	var can_afford := player_stats.gold >= COST
	disabled = not can_afford or player_stats.is_max_level()
	
	if can_afford and not player_stats.is_max_level():
		v_box_container.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		v_box_container.modulate = Color(1.0, 1.0, 1.0, 0.5)


func _on_pressed() -> void:
	player_stats.xp += XP_GAIN
	player_stats.gold -= COST
	SFXPlayer.play(buy_sound)
