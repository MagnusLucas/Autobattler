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
	var is_max_lvl := player_stats.level == player_stats.MAX_LEVEL
	disabled = not can_afford or is_max_lvl
	
	if can_afford and not is_max_lvl:
		v_box_container.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		v_box_container.modulate = Color(1.0, 1.0, 1.0, 0.5)


func _on_pressed() -> void:
	player_stats.xp += XP_GAIN
	player_stats.gold -= COST
	SFXPlayer.play(buy_sound)
