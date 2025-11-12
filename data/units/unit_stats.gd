class_name UnitStats
extends Resource

enum Rarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}

const RARITY_COLORS = {
	Rarity.COMMON: Color.WEB_GRAY,
	Rarity.UNCOMMON: Color.WEB_GREEN,
	Rarity.RARE: Color.DARK_BLUE,
	Rarity.EPIC: Color.DARK_VIOLET,
	Rarity.LEGENDARY: Color.GOLD,
}

@export var name : String

@export_category("Data")
@export var rarity: Rarity
@export var cost := 1
@export_range(1, 3) var tier := 1 : set = _set_tier
@export_range(0, 36, 9) var pool_count := 9

@export_category("Visuals")
@export var skin_coordinates: Vector2i


func _set_tier(value: int) -> void:
	tier = value
	emit_changed()


func _to_string() -> String:
	return name


func get_combined_unit_count() -> int:
	return 3**(tier - 1)


func get_gold_value() -> int:
	return get_combined_unit_count() * cost
