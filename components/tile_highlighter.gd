class_name TileHighlighter
extends TileMapLayer


@export var play_area: PlayArea
@export var tile: Vector2i

@onready var source_id := play_area.tile_set.get_source_id(0)


func _ready() -> void:
	hidden.connect(_on_hidden)


func _process(_delta: float) -> void:
	if not visible:
		return
	
	var selected_tile := play_area.get_hovered_tile()
	
	if not play_area.is_tile_in_bounds(selected_tile):
		clear()
		return
	
	_update_tile(selected_tile)

func _on_hidden() -> void:
	if play_area:
		clear()

func _update_tile(selected_tile: Vector2i) -> void:
	clear()
	set_cell(selected_tile, source_id, tile)
