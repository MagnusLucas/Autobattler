class_name  HealthBar
extends ProgressBar


@export var stats: UnitStats: set = _set_stats


func _set_stats(unit_stats: UnitStats) -> void:
	stats = unit_stats
	stats.changed.connect(_on_stats_changed)
	_on_stats_changed()


func _on_stats_changed() -> void:
	value = stats.health * 100.0 / stats.get_max_health()
