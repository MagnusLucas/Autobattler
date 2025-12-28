class_name TargetFinder
extends Node

signal targets_in_range_changed

@export var actor: BattleUnit

var target: BattleUnit
var targets_in_range: Array[BattleUnit]


func _ready() -> void:
	actor.ready.connect(
		func ():
			actor.detect_range.area_entered.connect(_on_area_entered)
			actor.detect_range.area_exited.connect(_on_area_exited)
	, CONNECT_ONE_SHOT)


func find_target() -> void:
	var opposing_group: String = UnitStats.TARGET[actor.stats.team]
	var all_enemies := get_tree().get_nodes_in_group(opposing_group)
	var distances := all_enemies.map(
		func(target_candidate: BattleUnit) -> float:
			return actor.global_position.distance_squared_to(target_candidate.global_position)
	)
	var idx := distances.find(distances.min())
	
	target = all_enemies[idx]


func has_target_in_range() -> bool:
	return targets_in_range.size() > 0


func _on_area_entered(enemy: Area2D) -> void:
	if not enemy is BattleUnit:
		return
	targets_in_range.append(enemy)
	targets_in_range_changed.emit()


func _on_area_exited(enemy: Area2D) -> void:
	if not enemy is BattleUnit:
		return
	targets_in_range.erase(enemy)
	targets_in_range_changed.emit()
