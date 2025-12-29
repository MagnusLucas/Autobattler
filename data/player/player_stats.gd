class_name PlayerStats
extends Resource

const MAX_LEVEL := 10
const XP_REQUIREMENTS := {
	1: 0,
	2: 2,
	3: 2,
	4: 6,
	5: 10,
	6: 20,
	7: 36,
	8: 48,
	9: 76,
	10: 76,
}

const MAX_UNITS := {
	1: 2,
	2: 2,
	3: 3,
	4: 3,
	5: 4,
	6: 4,
	7: 5,
	8: 6,
	9: 7,
	10: 8,
}

const ROLL_RARITIES := {
	1: [UnitStats.Rarity.COMMON],
	2: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON],
	3: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON],
	4: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE],
	5: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE],
	6: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE,
			UnitStats.Rarity.EPIC],
	7: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE,
			UnitStats.Rarity.EPIC],
	8: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE,
			UnitStats.Rarity.EPIC, UnitStats.Rarity.LEGENDARY],
	9: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE,
			UnitStats.Rarity.EPIC, UnitStats.Rarity.LEGENDARY],
	10: [UnitStats.Rarity.COMMON, UnitStats.Rarity.UNCOMMON, UnitStats.Rarity.RARE,
			UnitStats.Rarity.EPIC, UnitStats.Rarity.LEGENDARY],
}

const ROLL_CHANCES := {
	1: [1],
	2: [0.8, 0.2],
	3: [0.6, 0.4],
	4: [0.4, 0.5, 0.1],
	5: [0.2, 0.6, 0.2],
	6: [0.1, 0.5, 0.3, 0.1],
	7: [0.1, 0.3, 0.4, 0.2],
	8: [0.1, 0.2, 0.4, 0.25, 0.05],
	9: [0.1, 0.1, 0.3, 0.4, 0.1],
	10: [0.1, 0.1, 0.3, 0.3, 0.2],
}

@export_range(0, 99) var gold: int : set = _set_gold
@export_range(0, 99) var xp: int : set = _set_xp
@export_range(1, MAX_LEVEL) var level := 1 : set = _set_level


func get_random_rarity_for_level() -> UnitStats.Rarity:
	var rng := RandomNumberGenerator.new()
	var array: Array = ROLL_RARITIES[level]
	var weights := PackedFloat32Array(ROLL_CHANCES[level])
	
	return array[rng.rand_weighted(weights)]


func get_current_xp_requirement() -> int:
	return XP_REQUIREMENTS[level+1]


func get_current_max_units() -> int:
	return MAX_UNITS[level]


func is_max_level() -> bool:
	return level == MAX_LEVEL


func _set_gold(value: int) -> void:
	gold = value
	emit_changed()


func _set_xp(value: int) -> void:
	xp = value
	emit_changed()
	
	if is_max_level():
		return
	
	var xp_requirement := get_current_xp_requirement()
	while not is_max_level() and xp >= xp_requirement:
		xp -= xp_requirement
		xp_requirement = get_current_xp_requirement()
		level += 1
		emit_changed()

func _set_level(value: int) -> void:
	level = value
	emit_changed()
