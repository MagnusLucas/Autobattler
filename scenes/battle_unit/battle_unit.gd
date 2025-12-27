class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = _set_stats

@onready var unit_ai: UnitAI = $UnitAI

@onready var skin: PackedSprite2D = $Skin
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _set_stats(value: UnitStats) -> void:
	stats = value
	
	if not stats or not is_node_ready():
		return
	
	stats = stats.duplicate()
	collision_layer = stats.team + 1
	
	skin.texture = UnitStats.TEAM_SPRITESHEET[stats.team]
	skin.coordinates = stats.skin_coordinates
	skin.flip_h = stats.team == UnitStats.Team.PLAYER
	tier_icon.unit_stats = stats
