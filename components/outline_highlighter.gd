class_name OutlineHighlighter
extends Node

@export var area: Area2D
@export var visuals: CanvasGroup
@export var outline_colour: Color
@export_range(1, 5) var outline_thickness: int

func _ready() -> void:
	visuals.material.set_shader_parameter("line_color", outline_colour)
	if area:
		area.input_event.connect(_on_area_input_event.unbind(1))


func _on_area_input_event(_viewport: Viewport, event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not get_tree().get_first_node_in_group("dragging"):
			highlight()


func highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", outline_thickness)


func clear_highlight() -> void:
	visuals.material.set_shader_parameter("line_thickness", 0)
