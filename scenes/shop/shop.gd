class_name Shop
extends VBoxContainer

signal unit_bought(unit: UnitStats)

const CARDS_IN_SHOP := 5

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats

@onready var shop_cards: VBoxContainer = %ShopCards
@onready var scene_spawner: SceneSpawner = $SceneSpawner


func _ready() -> void:
	unit_pool.generate_unit_pool()
	
	for child in shop_cards.get_children():
		child.queue_free()
	
	_roll_units()


func _roll_units() -> void:
	for space in CARDS_IN_SHOP:
		var card: UnitCard = scene_spawner.spawn_scene(shop_cards)
		var rarity := player_stats.get_random_rarity_for_level()
		card.unit_stats = unit_pool.get_random_unit_by_rarity(rarity)
		card.unit_bought.connect(_on_unit_card_unit_bought)


func _on_reroll_button_pressed() -> void:
	_put_back_remaining_to_pool()
	_roll_units()


func _put_back_remaining_to_pool() -> void:
	for child: UnitCard in shop_cards.get_children():
		if not child.bought:
			unit_pool.add_unit(child.unit_stats)
		child.queue_free()


func _on_unit_card_unit_bought(unit: UnitStats) -> void:
	unit_bought.emit(unit)
