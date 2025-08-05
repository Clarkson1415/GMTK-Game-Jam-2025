extends Node

## GameSettings Class Global.
## Game settings that include video settings volume settings etc.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# SetWindowFullscreen(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	print("Viewport size: ", get_viewport().get_visible_rect().size)
	print("Window size: ", DisplayServer.window_get_size())
	print("Render resolution: ", get_viewport().get_texture().get_size())
	print("DPI: ", DisplayServer.screen_get_dpi())
	print("Display scale factor: ", DisplayServer.screen_get_scale())
	pass

func SetWindowFullscreen(setting: DisplayServer.WindowMode):
	DisplayServer.window_set_mode(setting)
