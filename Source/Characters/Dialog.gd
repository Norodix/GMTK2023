extends Control

@onready var label : Label = $Label
var label_timeout = 0

func _ready():
	SignalBus.connect("task_done", display_text)
	pass

func _process(delta):
	label_timeout -= delta
	label.visible = label_timeout > 0
	label.label_settings.font_size = Globals.font_size
	print(label_timeout)


var dialog_lines : Dictionary = {
	"TV" : "tv placeholder",
	
	"Bath" : "bath placeholder",
	
	"Toilette" : "toilette placeholder",
	
	"BathroomSink" : "bathroom sink placeholder",
	
	"Bed" : "bed placeholder",
	
	"Start" : "I'm a bit hungry. I know! I will ask my cat to feed me.
	He always just meows at me when he is hungry.
	There is no way it wont work",
	
	"KitchenSink" : "This is the kitchen sink...\nYou do know I'm hungry, right?",
	
	"Fridge" : "Finally!!\n ... \nNow that I think of it I'm not hungry anyway.",
}


func display_text(key : String):
	if not dialog_lines.has(key):
		print("Missing dialog with key: ", key)
		return
	label.text = dialog_lines[key]
	var wordcount = label.text.split(" ", false).size()
	label_timeout = wordcount / 1.5
	pass
