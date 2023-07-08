extends Node3D

@onready var anim : AnimationPlayer = $AnimationPlayer


func _on_agent_detector_body_entered(body):
	if ($AgentDetector.get_overlapping_bodies().size() == 1):
		anim.play("Open")


func _on_agent_detector_body_exited(body):
	if (not $AgentDetector.get_overlapping_bodies().is_empty()):
		return
	if anim.current_animation_position > 0:
		anim.play_backwards("Open")
