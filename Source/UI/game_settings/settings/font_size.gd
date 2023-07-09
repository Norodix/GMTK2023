@tool
extends ggsSetting

var size : int = 24

func _init() -> void:
	name = "FontSize"
	icon = preload("res://addons/ggs/assets/game_settings/display_size.svg")
	desc = "Change in-game font size"
	
	value_type = TYPE_INT
	default = 24


func apply(value: int) -> void:
	Globals.font_size = int(value)

