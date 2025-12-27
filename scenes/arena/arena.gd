class_name Arena
extends Node2D

const CELL_SIZE := Vector2(32, 32)
const HALF_CELL_SIZE := CELL_SIZE/2
const QUARTER_CELL_SIZE := HALF_CELL_SIZE/2

@export var music: AudioStream

@onready var sell_portal: SellPortal = $SellPortal
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_combiner: UnitCombiner = $UnitCombiner

@onready var shop: Shop = %Shop

@onready var game_area: PlayArea = $GameArea
@onready var battle_unit_grid: UnitGrid = $GameArea/BattleUnitGrid

func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	unit_spawner.unit_spawned.connect(unit_combiner.queue_unit_combination_update.unbind(1))
	shop.unit_bought.connect(unit_spawner.spawn_unit)
	MusicPlayer.play(music, true)
	UnitNavigation.initialize(battle_unit_grid, game_area)
