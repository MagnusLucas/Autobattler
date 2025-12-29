class_name XpTracker
extends VBoxContainer

@export var player_stats: PlayerStats

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var xp_label: Label = %XpLabel
@onready var level_label: Label = %LevelLabel


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	if not player_stats.is_max_level():
		_set_xp_bar_values()
	else:
		_set_max_level_values()
	
	level_label.text = "lvl: " + str(player_stats.level)


func _set_xp_bar_values() -> void:
	var xp_requirement := player_stats.get_current_xp_requirement()
	progress_bar.value = 100. * player_stats.xp / xp_requirement
	xp_label.text = "%s/%s" % [str(player_stats.xp), str(xp_requirement)]


func _set_max_level_values() -> void:
	progress_bar.value = 100
	xp_label.text = "MAX"
