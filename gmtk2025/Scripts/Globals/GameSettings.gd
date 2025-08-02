extends Node

## GameSettings Class Global.

## Level name to packed scene.
const _LEVEL_1 = preload("res://GameScenes/Level1.tscn")
const _LEVEL_2 = preload("res://GameScenes/Level2.tscn")

var _levelDictionary: Dictionary[int, PackedScene] = {0: _LEVEL_1, 1: _LEVEL_2}

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

signal LevelChanged

## Load game level. First starts from 1.
func LoadLevel(levelIndex: int):
	get_tree().change_scene_to_packed(_levelDictionary[levelIndex - 1])
	emit_signal("LevelChanged")
