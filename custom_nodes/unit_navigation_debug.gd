class_name UnitNavigationDebug
extends Node2D

@export var color: Color
@export var path_colors: Array[Color]
@export var game_area: PlayArea

var paths := {}


func _ready() -> void:
	UnitNavigation.path_calculated.connect(_on_path_calculated)


func _on_path_calculated(path: Array[Vector2i], unit: BattleUnit) -> void:
	paths[unit] = path
	queue_redraw()


func _draw() -> void:
	for i in UnitNavigation.astar_grid.region.size.x:
		for j in UnitNavigation.astar_grid.region.size.y:
			if UnitNavigation.astar_grid.is_point_solid(Vector2i(i, j)):
				draw_rect(Rect2(Vector2(i, j) * Arena.CELL_SIZE, Arena.CELL_SIZE), color)
	
	for path in paths:
		for i in range(0, paths[path].size() - 1):
			draw_line(game_area.get_global_from_tile(paths[path][i]) - global_position,
					game_area.get_global_from_tile(paths[path][i + 1]) - global_position,
					path_colors[0])
