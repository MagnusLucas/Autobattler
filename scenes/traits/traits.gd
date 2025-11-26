class_name Traits
extends VBoxContainer


@export var arena_grid: UnitGrid

@onready var scene_spawner: SceneSpawner = $SceneSpawner

var current_traits: Dictionary[Trait, TraitUI] = {}
var traits_to_update: Array[Trait] = []
var active_traits: Array[Trait] = []


func _ready() -> void:
	arena_grid.unit_grid_changed.connect(_update_traits)
	
	for child in get_children():
		if child is TraitUI:
			child.queue_free()


func _update_traits() -> void:
	traits_to_update = current_traits.keys()
	active_traits = []
	var units := arena_grid.get_all_units()
	var traits := Trait.get_unique_traits_for_units(units)
	
	for trait_data: Trait in traits:
		if current_traits.has(trait_data):
			_update_trait_ui(trait_data, units)
		else:
			_create_trait_ui(trait_data, units)
	
	_move_active_traits_to_top()
	_delete_orphan_traits()


func _update_trait_ui(trait_data: Trait, units: Array[Unit]) -> void:
	var trait_ui: TraitUI = current_traits[trait_data]
	trait_ui.update(units)
	traits_to_update.erase(trait_data)
	
	if trait_ui.active:
		active_traits.append(trait_data)


func _create_trait_ui(trait_data: Trait, units: Array[Unit]) -> void:
	var trait_ui: TraitUI = scene_spawner.spawn_scene()
	trait_ui.trait_data = trait_data
	trait_ui.update(units)
	
	if trait_ui.active:
		active_traits.append(trait_data)
	current_traits[trait_data] = trait_ui


func _move_active_traits_to_top() -> void:
	for i in active_traits.size():
		var trait_ui: TraitUI = current_traits[active_traits[i]]
		move_child(trait_ui, i)


func _delete_orphan_traits() -> void:
	# This happens after updating all the traits that units on board have
	# When updated they are deleted from traits_to_update
	# So the only left ones are the ones which were just removed from the board
	for trait_data: Trait in traits_to_update:
		var trait_ui: TraitUI = current_traits[trait_data]
		current_traits.erase(trait_data)
		trait_ui.queue_free()
