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

@export_range(0, 99) var gold: int : set = _set_gold
@export_range(0, 99) var xp: int : set = _set_xp
@export_range(1, 10) var level := 1 : set = _set_level


func get_current_xp_requirement() -> int:
	return XP_REQUIREMENTS[level+1]


func _set_gold(value: int) -> void:
	gold = value
	emit_changed()

func _set_xp(value: int) -> void:
	xp = value
	emit_changed()
	
	if level == MAX_LEVEL:
		return
	
	var xp_requirement := get_current_xp_requirement()
	while level < MAX_LEVEL and xp >= xp_requirement:
		xp -= xp_requirement
		xp_requirement = get_current_xp_requirement()
		level += 1
		emit_changed()

func _set_level(value: int) -> void:
	level = value
	emit_changed()
