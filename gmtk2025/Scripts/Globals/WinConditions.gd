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
	if terminalsPowered() and !GlobalDragging.IsDragging():
		await get_tree().create_timer(0.5).timeout.connect(onWinCheckTimeout) # Waits for 2 seconds

func onWinCheckTimeout():
	if terminalsPowered() and !GlobalDragging.IsDragging():
		currentLevelsTerminals.clear()
		GameLevels.NextLevel()

func terminalsPowered() -> bool:
	if len(currentLevelsTerminals) == 0:
		return false
	for terminal in currentLevelsTerminals:
		if !terminal.IsTerminalPowered():
			return false
	return true
