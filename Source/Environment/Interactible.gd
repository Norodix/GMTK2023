extends Area3D

signal activate

func interact():
	self.emit_signal("activate")
	print("interacted with ", self)
