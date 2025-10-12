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

@export_category("Visuals")
@export var skin_coordinates: Vector2i

func _to_string() -> String:
	return name
