extends Node

## GameSettings Class Global.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# SetWindowFullscreen(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	pass

func SetWindowFullscreen(setting: DisplayServer.WindowMode):
	DisplayServer.window_set_mode(setting)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
