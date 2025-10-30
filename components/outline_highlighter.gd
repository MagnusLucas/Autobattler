class_name OutlineHighlighter
extends Node

@export var visuals: CanvasGroup
@export var outline_colour: Color
@export_range(1, 5) var outline_thickness: int

func _ready() -> void:
	visuals.material.set_shader_parameter("line_color", outline_colour)

func highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", outline_thickness)


func clear_highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", 0)
