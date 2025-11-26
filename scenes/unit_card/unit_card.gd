class_name UnitCard
extends Button

signal unit_bought(unit: UnitStats)

const HOVER_BORDER_COLOR := Color(0.737, 0.513, 0.039, 1.0)

@export var player_stats: PlayerStats
@export var unit_stats: UnitStats : set = _set_unit_stats

@onready var traits: Label = %Traits
@onready var bottom: Panel = %Bottom
@onready var unit_name: Label = %UnitName
@onready var gold_cost: Label = %GoldCost
@onready var border: Panel = %Border
@onready var unit_icon: TextureRect = %UnitIcon
@onready var empty_placeholder: Panel = %EmptyPlaceholder
@onready var sb_bottom: StyleBoxFlat = bottom.get_theme_stylebox("panel")
@onready var sb_border: StyleBoxFlat = border.get_theme_stylebox("panel")

var bought := false
var border_color: Color


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	if not unit_stats:
		return
	
	var has_enough_gold := player_stats.gold >= unit_stats.cost
	disabled = not has_enough_gold
	
	if has_enough_gold or bought:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 0.498)


func _set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	
	if not is_node_ready():
		await ready
	
	if not unit_stats:
		empty_placeholder.show()
		disabled = true
		bought = true
		return
	
	border_color = UnitStats.RARITY_COLORS[unit_stats.rarity]
	sb_border.border_color = border_color
	sb_bottom.bg_color = border_color
	traits.text = ""
	unit_name.text = unit_stats.name
	gold_cost.text = str(unit_stats.cost)
	traits.text = "\n".join(Trait.get_trait_names(unit_stats.traits))
	unit_icon.texture.region.position = Vector2(unit_stats.skin_coordinates) * Arena.CELL_SIZE


func _on_pressed() -> void:
	if bought:
		return
	
	bought = true
	empty_placeholder.show()
	player_stats.gold -= unit_stats.cost
	unit_bought.emit(unit_stats)


func _on_mouse_entered() -> void:
	if not disabled:
		sb_border.border_color = HOVER_BORDER_COLOR


func _on_mouse_exited() -> void:
	sb_border.border_color = border_color
