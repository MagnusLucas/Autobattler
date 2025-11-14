class_name OutlineHighlighter
extends Node

signal got_enabled

@export var enabled := true : set = _set_enabled
@export var visuals: CanvasGroup
@export var outline_colour: Color
@export_range(1, 5) var outline_thickness: int

func _ready() -> void:
	visuals.material.set_shader_parameter("line_color", outline_colour)


func highlight() -> void:
	if not enabled:
		return
	visuals.material.set_shader_parameter("line_thickness", outline_thickness)


func clear_highlight() -> void:
	if not enabled:
		return
	visuals.material.set_shader_parameter("line_thickness", 0)


func _set_enabled(value: bool) -> void:
	enabled = value
	if not enabled:
		clear_highlight()
	else:
		got_enabled.emit()
	
