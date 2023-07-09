extends Node3D


func _ready():
	SignalBus.emit_signal("task_done", "Start")
	$Ceiling.visible = true
