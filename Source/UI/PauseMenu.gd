extends Control

var paused : bool = false

func _ready():
	paused = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = not paused
	
#	Engine.time_scale = int(paused)
	get_tree().paused = paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED)
	self.mouse_filter = Control.MOUSE_FILTER_STOP if paused else Control.MOUSE_FILTER_IGNORE
	self.visible = paused


func _on_resume_pressed():
	paused = false
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit(0)
	pass # Replace with function body.
