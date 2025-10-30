class_name VelocityBasedRotation
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var target: Node2D
@export_range(0.25, 1.5) var lerp_seconds := 0.4
@export var max_rotation_degrees := 50
@export var velocity_at_max_rotation := 100.0

var last_position: Vector2
var velocity: Vector2
var angle: float
var progress: float
var time_elapsed := 0.0

func _physics_process(delta: float) -> void:
	if not enabled or not target:
		return
	velocity = target.global_position - last_position
	last_position = target.global_position
	progress = time_elapsed/lerp_seconds
	
	var rotation_strength: float = velocity.x / delta / velocity_at_max_rotation
	var rotation_strength_clamped: float = clamp(rotation_strength, -1, 1)
	angle = lerp_angle(0, deg_to_rad(max_rotation_degrees), rotation_strength_clamped)
	
	target.rotation = lerp_angle(target.rotation, angle, progress)
	time_elapsed += delta
	
	if progress > 1.0:
		time_elapsed = 0.0

func _set_enabled(value : bool) -> void:
	enabled = value
	
	if target and not enabled:
		target.rotation = 0.0
