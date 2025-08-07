extends Node

## Level name to packed scene.
const _LEVEL_1 = preload("res://GameScenes/Level1.tscn")
const _LEVEL_2 = preload("res://GameScenes/Level2.tscn")
const LEVEL_3 = preload("res://GameScenes/Level3.tscn")
const LEVEL_4 = preload("res://GameScenes/Level4.tscn")

var _levelDictionary: Dictionary[int, PackedScene] = {1: _LEVEL_1, 2: _LEVEL_2, 3: LEVEL_3, 4: LEVEL_4}
var currentLevelIndex: int = 1

signal LevelChanged

func NextLevel(timeDelay: float = 1.0):
	await get_tree().create_timer(1).timeout
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
