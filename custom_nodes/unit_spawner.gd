class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

@export var bench: PlayArea
@export var game_area: PlayArea
@export var game_state: GameState

@onready var scene_spawner: SceneSpawner = $SceneSpawner

func _get_first_aviable_area() -> PlayArea:
	var bench_full := bench.unit_grid.is_grid_full()
	var game_area_full := game_area.unit_grid.is_grid_full()
	
	if not bench_full:
		return bench
	elif not game_area_full and not game_state.is_battling():
		return game_area
	return null


func spawn_unit(unit_stats: UnitStats) -> void:
	var area := _get_first_aviable_area()
	
	# TODO: This should be showing a popup, not crashing the game
	assert(area, "No available space to spawn the unit to!")
	
	var unit: Unit = scene_spawner.spawn_scene(area.unit_grid)
	var tile: Vector2i = area.unit_grid.get_first_empty_tile()
	area.unit_grid.add_unit(tile, unit)
	unit.stats = unit_stats
	unit.global_position = area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	unit_spawned.emit(unit)
