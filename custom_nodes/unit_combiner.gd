class_name UnitCombiner
extends Node


@export var buffer_timer: Timer
@export var combine_sound: AudioStream

var queued_updates := 0
var tween: Tween

func _ready() -> void:
	buffer_timer.timeout.connect(_on_buffer_timer_timeout)


func queue_unit_combination_update() -> void:
	buffer_timer.start()


func _update_unit_combinations(tier: int) -> void:
	var units_by_name: Dictionary = _get_groups_of_tier_by_name(tier)
	var triplets: Array[Array] = _get_triplets(units_by_name)
	
	if triplets.size() == 0:
		_on_units_combined(tier)
		return
	
	tween = create_tween()
	
	for combination in triplets:
		tween.tween_callback(_combine_units.bind(
				combination[0], combination[1], combination[2]))
		tween.tween_interval(UnitAnimations.COMBINE_ANIM_LENGTH)
	
	tween.finished.connect(_on_units_combined.bind(tier), CONNECT_ONE_SHOT)


func _combine_units(unit_0: Unit, unit_1: Unit, unit_2: Unit) -> void:
	unit_0.stats.tier += 1
	unit_1.remove_from_group("units")
	unit_2.remove_from_group("units")
	unit_1.animations.play_combine_animation(
			unit_0.global_position + Arena.QUARTER_CELL_SIZE)
	unit_2.animations.play_combine_animation(
			unit_0.global_position + Arena.QUARTER_CELL_SIZE)
	SFXPlayer.play(combine_sound)


func _on_units_combined(tier: int) -> void:
	if tier == 1:
		_update_unit_combinations(2)
	else:
		queued_updates -= 1
		if queued_updates > 0:
			_update_unit_combinations(1)


func _get_groups_of_tier_by_name(tier: int) -> Dictionary[String, Array]:
	var groups: Dictionary[String, Array] = {}
	
	var units := get_tree().get_nodes_in_group("units")
	var filtered_units := units.filter(
		func(unit: Unit) -> bool:
			return unit.stats.tier == tier
	)
	
	for unit: Unit in filtered_units:
		if groups.has(unit.stats.name):
			groups[unit.stats.name].append(unit)
		else:
			groups[unit.stats.name] = [unit]
	
	return groups

# The inner array is Array[Unit], consists of 3 units
func _get_triplets(groups: Dictionary[String, Array]) -> Array[Array]:
	var triplets: Array[Array]
	for unit_name in groups:
		var current_units: Array[Unit]
		current_units.assign(groups[unit_name])
		while current_units.size() >= 3:
			triplets.append([current_units[0], current_units[1], current_units[2]])
			current_units = current_units.slice(3)
	
	return triplets



func _on_buffer_timer_timeout() -> void:
	queued_updates += 1
	
	if not tween or not tween.is_running():
		_update_unit_combinations(1)
