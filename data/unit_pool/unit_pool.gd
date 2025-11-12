class_name UnitPool
extends Resource

@export var available_units: Array[UnitStats]

var unit_pool: Array[UnitStats] = []


func generate_unit_pool() -> void:
	unit_pool = []
	for unit in available_units:
		for i in unit.pool_count:
			unit_pool.append(unit.duplicate())


func get_random_unit_by_rarity(rarity: UnitStats.Rarity) -> UnitStats:
	var units_of_rarity := unit_pool.filter(
		func(unit: UnitStats) -> bool:
			return unit.rarity == rarity
	)
	if units_of_rarity.is_empty():
		return null
	
	var random_unit: UnitStats = units_of_rarity.pick_random()
	unit_pool.erase(random_unit)
	return random_unit


func add_unit(unit: UnitStats) -> void:
	var combined_count := unit.get_combined_unit_count()
	
	#unit = unit.duplicate() # I'm not sure this is needed?
	unit.tier = 1
	for i in combined_count:
		unit_pool.append(unit)
