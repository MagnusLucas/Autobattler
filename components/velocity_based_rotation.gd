class_name VelocityBasedRotation
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var target: Node2D
@export_range(0.25, 1.5) var lerp_seconds := 0.4
@export var max_rotation_degrees := 50
@export var x_velocity_lower_threshold := 1.0
@export var x_velocity_upper_threshold := 3.0

var last_position: Vector2
var velocity: Vector2
var angle: float
var progress: float
var time_elapsed := 0.0

func easeInOutQuad(x: float) -> float:
	return 2 * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 2) / 2;

func _physics_process(delta: float) -> void:
	if not enabled or not target:
		return
	velocity = target.global_position - last_position
	last_position = target.global_position
	progress = time_elapsed/lerp_seconds
	
	if abs(velocity.x) > x_velocity_upper_threshold:
		angle = velocity.normalized().x * deg_to_rad(max_rotation_degrees)
	elif angle != 0 and abs(velocity.x) > x_velocity_lower_threshold:
		angle = velocity.normalized().x * deg_to_rad(max_rotation_degrees)
		time_elapsed = 0.3
	else:
		angle = 0.0
	
	target.rotation = lerp_angle(target.rotation, angle, easeInOutQuad(progress))
	time_elapsed += delta
	
	if progress > 1.0:
		time_elapsed = 0.0

func _set_enabled(value : bool) -> void:
	enabled = value
	
	if target and not enabled:
		target.rotation = 0.0
