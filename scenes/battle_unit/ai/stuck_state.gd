class_name StuckState
extends State

signal timeout

const STUCK_WAIT_TIME := 0.3

var elapsed := 0.0


func physics_process(delta: float) -> void:
	elapsed += delta
	if elapsed >= STUCK_WAIT_TIME:
		timeout.emit()
