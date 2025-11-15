class_name TeamSizeUI
extends PanelContainer

@export var player_stats: PlayerStats
@export var arena_unit_grid: UnitGrid

@onready var unit_counter: Label = %UnitCounter
@onready var too_many_units_icon: TextureRect = %TooManyUnitsIcon


func _ready() -> void:
	arena_unit_grid.unit_grid_changed.connect(_update)
	player_stats.changed.connect(_update)
	_update()


func _update() -> void:
	var max_units := player_stats.get_current_max_units()
	var current_units := arena_unit_grid.get_all_units().size()
	unit_counter.text = "%s/%s" % [current_units, max_units]
	
	if current_units > max_units:
		too_many_units_icon.show()
	else:
		too_many_units_icon.hide()
