extends Node3D


func _on_node_3d_activate():
	SignalBus.emit_signal("task_done", "TV")
	$Sprite3D.visible = true
	pass # Replace with function body.
