class_name BattleHandler
extends Node

signal player_won
signal enemy_won

@export var game_state: GameState
@export var game_area: PlayArea
@export var game_area_unit_grid: UnitGrid
@export var battle_unit_grid: UnitGrid

@onready var scene_spawner: SceneSpawner = $SceneSpawner


func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)


func _clear_up_fight() -> void:
	get_tree().call_group("units", "show")


func _prepare_fight() -> void:
	get_tree().call_group("units", "hide")


func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clear_up_fight()
		GameState.Phase.BATTLE:
			_prepare_fight()
