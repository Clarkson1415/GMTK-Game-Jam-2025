extends Node

## Global WinConditions Script

var currentLevelsTerminals: Array[PowerTerminal]

func SetupWinConditions() -> void:
	currentLevelsTerminals.clear()
	for node in get_tree().current_scene.get_children():
		if node is PowerTerminal:
			currentLevelsTerminals.append(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if len(currentLevelsTerminals) == 0:
		return
	for terminal in currentLevelsTerminals:
		if !terminal.IsTerminalPowered():
			return
	print("TODO wait 1 second before next level.")
	currentLevelsTerminals.clear()
	GameSettings.NextLevel()
