class_name TierIcon
extends TextureRect

const TIER_ICONS := {
	1: preload("uid://cj1cl8jdui60n"),
	2: preload("uid://cnreie73qy5rv"),
	3: preload("uid://ctgdgvg8lfsn5"),
}

@export var unit_stats: UnitStats : set = _set_stats


func _set_stats(value: UnitStats) -> void:
	if unit_stats == value:
		return
	
	unit_stats = value
	if unit_stats == null:
		return
	
	unit_stats.changed.connect(_on_stats_changed)
	_on_stats_changed()

func _on_stats_changed() -> void:
	texture = TIER_ICONS[unit_stats.tier]
