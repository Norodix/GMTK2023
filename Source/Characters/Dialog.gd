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


var dialog_lines : Dictionary = {
	"BathroomSink" : "No, you misunderstood me. I'm hungry, not thirsty.",
	
	"TV" : "I don't want to watch TV.
	Although that is a pretty good programme.",
	
	"KitchenSink" : "Yes! YES! NOOOO!
	What did I just tell you about not being thirsty!",
	
	"Lamp" : "It's broad daylight.
	That is not very environment friendly.",
	
	"Bath" : "A bath? Are you suggesting something?
	You know what? No. You smell!",
	
	"Bed" : "Did you really just have to mess that up?
	You are getting on my nerves. Just feed me already!",
	
	"Toilette" : "One more like this and I'm gonna flush you!",
	
	"Start" : "I'm a bit hungry. I know! I will ask my cat to feed me.
	He always just meows at me when he is hungry.
	There is no way it wont work",
	
	"Fridge" : "Finally!!\n ... \nNow that I think of it I'm not hungry anyway.
	
	The end.
	Thanks for playing!",
}


func display_text(key : String):
	if not dialog_lines.has(key):
		print("Missing dialog with key: ", key)
		return
	label.text = dialog_lines[key]
	var wordcount = label.text.split(" ", false).size()
	label_timeout = wordcount / 2 + 2
	pass
