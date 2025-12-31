extends Node

signal path_calculated(points: Array[Vector2i], unit: BattleUnit)

var battle_grid: UnitGrid
var game_area: PlayArea
var astar_grid: AStarGrid2D
var full_grid_region: Rect2i


func initialize(grid: UnitGrid, area: PlayArea) -> void:
	battle_grid = grid
	game_area = area
	
	full_grid_region = Rect2i(Vector2i.ZERO, battle_grid.size)
	astar_grid = AStarGrid2D.new()
	astar_grid.region = full_grid_region
	astar_grid.cell_size = Arena.CELL_SIZE
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	battle_grid.unit_grid_changed.connect(update_occupied_tiles)


func update_occupied_tiles() -> void:
	astar_grid.fill_solid_region(full_grid_region, false)
	for id: Vector2i in battle_grid.get_all_occupied_tiles():
		astar_grid.set_point_solid(id)


func get_next_position(unit: BattleUnit, target: BattleUnit) -> Vector2:
	var unit_tile := game_area.get_tile_from_global(unit.global_position)
	var target_tile := game_area.get_tile_from_global(target.global_position)
	
	astar_grid.set_point_solid(unit_tile, false)
	var path := astar_grid.get_id_path(unit_tile, target_tile, true)
	path_calculated.emit(path, unit)
	
	# There's no tile to move to
	if path.size() <= 1:
		astar_grid.set_point_solid(unit_tile)
		return Vector2(-1, -1)
	
	# Handle movement
	var next_cell := path[1]
	battle_grid.remove_unit(unit_tile)
	battle_grid.add_unit(next_cell, unit)
	astar_grid.set_point_solid(next_cell)
	
	return game_area.get_global_from_tile(next_cell)
