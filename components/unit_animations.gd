class_name UnitAnimations
extends Node

const COMBINE_ANIM_LENGTH := 0.6
const COMBINE_ANIM_SCALE := Vector2(0.7, 0.7)
const COMBINE_ANIM_ALPHA := 0.5

@export var unit: Unit


func play_combine_animation(target_position: Vector2) -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	unit.health_bar.hide()
	unit.mana_bar.hide()
	unit.tier_icon.hide()
	tween.tween_property(unit, "global_position", target_position, COMBINE_ANIM_LENGTH)
	tween.parallel().tween_property(unit, "scale", COMBINE_ANIM_SCALE, COMBINE_ANIM_LENGTH)
	tween.parallel().tween_property(unit, "modulate:a", COMBINE_ANIM_ALPHA, COMBINE_ANIM_LENGTH)
	tween.tween_callback(unit.queue_free)


func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		play_combine_animation(get_viewport().get_mouse_position())
