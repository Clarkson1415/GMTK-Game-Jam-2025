extends Node2D

## Is not an autoload. add this script to parent node of every level scene. Will initialise win conditions.
class_name LevelInitialiser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WinConditions.SetupWinConditions()
	EscapeUi.updateLevelLabel()
	EscapeUi.SetPixelPerfectScale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
