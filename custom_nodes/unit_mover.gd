class_name UnitMover
extends Node

@export var play_areas: Array[PlayArea] = []
@export var place_sound: AudioStream
@export var game_state: GameState

func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit : Unit in units:
		setup_unit(unit)


func _get_play_area_from_position(global: Vector2) -> PlayArea:
	for play_area in play_areas:
		var tile: Vector2i = play_area.get_tile_from_global(global)
		if play_area.is_tile_in_bounds(tile):
			return play_area
	
	return null


func _reset_unit_to_starting_posiiton(starting_position: Vector2, unit: Unit) -> void:
	var play_area := _get_play_area_from_position(starting_position)
	var tile := play_area.get_tile_from_global(starting_position)
	
	unit.reset_after_dragging(starting_position)
	play_area.unit_grid.add_unit(tile, unit)
	SFXPlayer.play(place_sound)


func _move_unit(unit: Unit, play_area: PlayArea, tile: Vector2i) -> void:
	play_area.unit_grid.add_unit(tile, unit)
	unit.global_position = play_area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	unit.reparent(play_area.unit_grid)


func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlighters(true)
	var play_area: PlayArea = _get_play_area_from_position(unit.global_position)
	if play_area:
		var tile := play_area.get_tile_from_global(unit.global_position)
		play_area.unit_grid.remove_unit(tile)


func _on_unit_dropped(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	var play_area: PlayArea = _get_play_area_from_position(unit.get_global_mouse_position())
	
	var invalid_drop := play_area == null
	var drop_on_bench := play_area.name == "Bench" if play_area else false
	
	if invalid_drop or (game_state.is_battling() and not drop_on_bench):
		_reset_unit_to_starting_posiiton(starting_position, unit)
		return
	var tile := play_area.get_hovered_tile()
	
	if play_area.unit_grid.is_tile_occupied(tile):
		var other_unit: Unit = play_area.unit_grid.units[tile]
		play_area.unit_grid.remove_unit(tile)
		var other_play_area = _get_play_area_from_position(starting_position)
		var other_tile = other_play_area.get_tile_from_global(starting_position)
		_move_unit(other_unit, other_play_area, other_tile)
	
	_move_unit(unit, play_area, tile)
	SFXPlayer.play(place_sound)


func _on_unit_drag_canceled(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	_reset_unit_to_starting_posiiton(starting_position, unit)


func _set_highlighters(visible: bool) -> void:
	for play_area in play_areas:
		play_area.tile_highlighter.visible = visible


func setup_unit(unit : Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
