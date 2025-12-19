class_name StartBattleButton
extends Button

@export var player_stats: PlayerStats
@export var arena_grid: UnitGrid
@export var game_state: GameState

@onready var icon_texture: TextureRect = $Icon


func _ready() -> void:
	pressed.connect(_on_pressed)
	player_stats.changed.connect(_update)
	arena_grid.unit_grid_changed.connect(_update)
	game_state.changed.connect(_update)
	_update()


func _update() -> void:
	var units_on_board := arena_grid.get_all_units().size()
	var max_units := player_stats.get_current_max_units()
	var preparation := game_state.current_phase == GameState.Phase.PREPARATION
	
	disabled = units_on_board > max_units or not preparation or units_on_board == 0
	icon_texture.modulate.a = 0.5 if disabled else 1.0


func _on_pressed() -> void:
	if game_state.current_phase != GameState.Phase.PREPARATION:
		return
	game_state.current_phase = GameState.Phase.BATTLE
