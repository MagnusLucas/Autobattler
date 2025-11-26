class_name Trait
extends Resource

const HIGHLIGHT_COLOR := Color("fafa82")

@export var name: String
@export var icon: Texture
@export_multiline var description: String

@export_range(1, 5) var levels: int
@export var unit_requirements: Array[int]
@export var unit_modifiers: Array[PackedScene]


static func get_unique_traits_for_units(units: Array[Unit]) -> Array[Trait]:
	var traits: Array[Trait] = []
	
	for unit in units:
		for unit_trait in unit.stats.traits:
			if !traits.has(unit_trait):
				traits.append(unit_trait)
	
	return traits


func get_unique_unit_count(units: Array[Unit]) -> int:
	var units_with_trait := units.filter(
		func(unit: Unit) -> bool:
			return unit.stats.traits.has(self)
	)
	
	var unique_units: Array[String] = []
	
	for unit: Unit in units_with_trait:
		if !unique_units.has(unit.stats.name):
			unique_units.append(unit.stats.name)
	
	return unique_units.size()


func get_levels_bbcode(unit_count: int) -> String:
	var code: PackedStringArray =[]
	var reached_level := unit_requirements.filter(
		func(requirement: int):
			return unit_count >= requirement
	)
	
	for i: int in levels:
		if i == (reached_level.size() -1):
			code.append("[color=#%s]%s[/color]" % [HIGHLIGHT_COLOR, unit_requirements[i]])
		else:
			code.append(str(unit_requirements[i]))
	
	return "/".join(code)


func is_active(unique_unit_count: int) -> bool:
	return unique_unit_count >= unit_requirements[0]
