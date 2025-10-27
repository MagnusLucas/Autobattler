class_name DragAndDrop
extends Node

signal drag_canceled(starting_position: Vector2)
signal drag_started
signal dropped(starting_position: Vector2)

@export var enabled: bool = true
@export var target: Area2D

var starting_position: Vector2
var offset := Vector2.ZERO
var dragging := false

func _ready() -> void:
	assert(target, "No target set for Drag And Drop component!")
	target.input_event.connect(_on_target_input_event.unbind(1))


func _process(_delta: float) -> void:
	if dragging and target:
		target.global_position = target.get_global_mouse_position() + offset

# Doesn't require mouse over area2d
func _input(event: InputEvent) -> void:
	if dragging:
		if event.is_action_released("select"):
			_drop()
		elif event.is_action("cancel_drag"):
			_cancel_dragging()

func _end_dragging() -> void:
	dragging = false
	target.remove_from_group("dragging")
	offset = Vector2.ZERO
	target.z_index = 0

func _cancel_dragging() -> void:
	_end_dragging()
	target.global_position = starting_position
	drag_canceled.emit(starting_position)

func _start_dragging() -> void:
	dragging = true
	starting_position = target.global_position
	offset = -target.get_local_mouse_position()
	target.add_to_group("dragging")
	target.z_index = 99
	drag_started.emit()

func _drop() -> void:
	_end_dragging()
	dropped.emit(starting_position)

# Does require mouse over area2d
func _on_target_input_event(_viewport: Node, event: InputEvent) -> void:
	if not enabled or not target:
		return
	
	# Making sure it's impossible to start dragging another unit if you're
	# already dragging one
	var dragging_object := get_tree().get_first_node_in_group("dragging")
	if not dragging and dragging_object:
		return
	
	if event.is_action_pressed("select") and not dragging:
		_start_dragging()
	
