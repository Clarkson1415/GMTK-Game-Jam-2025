extends Label

class_name CurrentLevelText

# Called when the node enters the scene tree for the first time.
func UpdateLevelText() -> void:
	text = "Level " + str(GameLevels.currentLevelIndex)
