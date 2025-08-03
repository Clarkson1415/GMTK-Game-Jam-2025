extends Node

## GameSettings Class Global.

## Level name to packed scene.
const _LEVEL_1 = preload("res://GameScenes/Level1.tscn")
const _LEVEL_2 = preload("res://GameScenes/Level2.tscn")
const LEVEL_3 = preload("res://GameScenes/Level3.tscn")

var _levelDictionary: Dictionary[int, PackedScene] = {1: _LEVEL_1, 2: _LEVEL_2, 3: LEVEL_3}
var currentLevelIndex: int = 1

signal LevelChanged

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

func NextLevel():
	LoadLevel(currentLevelIndex + 1)

## Load game level. First starts from 1.
func LoadLevel(levelIndex: int):
	GlobalDragging.ToggleDragging(false)
	currentLevelIndex = levelIndex
	if levelIndex > len(_levelDictionary):
		push_warning("Tried to load level that does not exist within the bounds of the level dict.")
		return
	get_tree().change_scene_to_packed(_levelDictionary[levelIndex])
	emit_signal("LevelChanged")
