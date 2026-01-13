class_name UnitStats
extends Resource

signal health_reached_zero
signal mana_bar_filled


enum Rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}
enum Team {
	PLAYER,
	ENEMY
}

const RARITY_COLORS = {
	Rarity.COMMON: Color.WEB_GRAY,
	Rarity.UNCOMMON: Color.WEB_GREEN,
	Rarity.RARE: Color.DARK_BLUE,
	Rarity.EPIC: Color.DARK_VIOLET,
	Rarity.LEGENDARY: Color.GOLD,
}

const TARGET := {
	Team.PLAYER : "enemy_units",
	Team.ENEMY : "player_units"
}

const TEAM_SPRITESHEET := {
	Team.PLAYER : preload("uid://cx1ivjobggp8n"),
	Team.ENEMY : preload("uid://ct4xk88g67xlv")
}

const MOVE_ONE_TILE_SPEED = 0.5
const MAX_ATTACK_RANGE := 5
const MANA_PER_ATTACK := 10

@export var name : String

@export_category("Data")
@export var rarity: Rarity
@export var cost := 1
@export_range(1, 3) var tier := 1 : set = _set_tier
@export_range(0, 36, 9) var pool_count := 9
@export var traits: Array[Trait] = []

@export_category("Visuals")
@export var skin_coordinates: Vector2i

@export_category("Battle")
@export var team: Team
@export var max_health: Array[int] = [10, 20, 30]
@export var max_mana: int
@export var starting_mana: int
@export var attack_damage: Array[int] = [2, 3, 4]
@export var ability_power: int
@export var attack_speed: float = 1.0
@export var armor: int
@export var magic_resist: int
@export_range(1, MAX_ATTACK_RANGE) var attack_range: int
@export var melee_attack: PackedScene = preload("uid://cub2sg6rvnhuw")
@export var ranged_attack: PackedScene
@export var ability: PackedScene
@export var auto_attack_sound: AudioStream

var health: int: set = _set_health
var mana: int: set = _set_mana


func reset_health() -> void:
	health = get_max_health()


func reset_mana() -> void:
	mana = starting_mana


func get_combined_unit_count() -> int:
	return 3**(tier - 1)


func get_gold_value() -> int:
	return get_combined_unit_count() * cost


func get_max_health() -> int:
	return max_health[tier - 1]


func get_attack_damage() -> int:
	return attack_damage[tier - 1]


func get_time_between_attacks() -> float:
	return 1 / attack_speed


func get_team_collision_layer() -> int:
	return team + 1


func get_team_collision_mask() -> int:
	return 2 - team


func is_melee() -> bool:
	return attack_range == 1


func _set_tier(value: int) -> void:
	tier = value
	emit_changed()


func _set_health(value: int) -> void:
	health = value
	emit_changed()
	
	if health <= 0:
		health_reached_zero.emit()


func _set_mana(value: int) -> void:
	mana = value
	emit_changed()
	
	if mana >= max_mana and max_mana > 0:
		mana_bar_filled.emit()

func _to_string() -> String:
	return name
