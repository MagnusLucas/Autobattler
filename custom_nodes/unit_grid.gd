class_name  UnitGrid
extends Node2D

signal unit_grid_changed

@export var size : Vector2i

var units : Dictionary[Vector2i, Variant]


func _ready() -> void:
	for x in size.x:
		for y in size.y:
			units[Vector2i(x, y)] = null


func add_unit(tile: Vector2i, unit: Variant) -> void:
	units[tile] = unit
	unit_grid_changed.emit()
	unit.tree_exited.connect(_on_unit_tree_exited.bind(unit, tile))


func _on_unit_tree_exited(unit: Unit, tile: Vector2i) -> void:
	if unit.is_queued_for_deletion():
		units[tile] = null
		unit_grid_changed.emit()


func remove_unit(tile: Vector2i) -> void:
	if units[tile] == null:
		return
	
	units[tile].tree_exited.disconnect(_on_unit_tree_exited)
	units[tile] = null
	unit_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null


func get_all_occupied_tiles() -> Array[Vector2i]:
	return units.keys().filter(func(tile): return is_tile_occupied(tile))


func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)


func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if !is_tile_occupied(tile):
			return tile
	
	# There are no empty tiles
	return Vector2i(-1, -1)


func get_all_units() -> Array[Unit]:
	var unit_array: Array[Unit] = []
	for value: Unit in units.values():
		if value != null:
			unit_array.append(value)
	
	return unit_array
