class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = _set_stats

@onready var unit_ai: UnitAI = $UnitAI

@onready var skin: PackedSprite2D = $Skin
@onready var detect_range: DetectRange = $DetectRange
@onready var hurt_box: HurtBox = $HurtBox
@onready var health_bar: HealthBar = $HealthBar
@onready var mana_bar: ManaBar = $ManaBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var attack_timer: Timer = $AttackTimer
@onready var target_finder: TargetFinder = $TargetFinder
@onready var flip_sprite: FlipSprite = $FlipSprite
@onready var melee_attack: Attack = $MeleeAttack
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hurt_box.hurt.connect(_on_hurt)


func _on_hurt(damage: int) -> void:
	stats.health -= damage


func _set_stats(value: UnitStats) -> void:
	stats = value
	
	if not stats or not is_node_ready():
		return
	
	stats = stats.duplicate()
	stats.reset_health()
	collision_layer = stats.get_team_collision_layer()
	hurt_box.collision_layer = stats.get_team_collision_layer()
	hurt_box.collision_mask = stats.get_team_collision_mask()
	
	skin.texture = UnitStats.TEAM_SPRITESHEET[stats.team]
	skin.coordinates = stats.skin_coordinates
	skin.flip_h = stats.team == UnitStats.Team.PLAYER
	
	melee_attack.spawner.scene = stats.melee_attack
	
	tier_icon.unit_stats = stats
	health_bar.stats = stats
	mana_bar.stats = stats
	detect_range.stats = stats
	stats.health_reached_zero.connect(queue_free)
