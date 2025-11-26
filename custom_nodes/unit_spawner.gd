class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

@export var bench: PlayArea
@export var game_area: PlayArea

@onready var scene_spawner: SceneSpawner = $SceneSpawner

func _get_first_aviable_area() -> PlayArea:
	if not bench.unit_grid.is_grid_full():
		return bench
	elif not game_area.unit_grid.is_grid_full():
		return game_area
	return null


func spawn_unit(unit_stats: UnitStats) -> void:
	var area := _get_first_aviable_area()
	
	assert(area, "No aviable space to spawn the unit to!")
	
	var unit: Unit = scene_spawner.spawn_scene(area.unit_grid)
	var tile: Vector2i = area.unit_grid.get_first_empty_tile()
	area.unit_grid.add_unit(tile, unit)
	unit.set_stats(unit_stats)
	unit.global_position = area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	unit_spawned.emit(unit)
