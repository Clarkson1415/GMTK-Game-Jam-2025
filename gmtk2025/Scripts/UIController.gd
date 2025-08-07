extends CanvasLayer

class_name UIController

@export var levelText: CurrentLevelText

## Scales canvas by camera zoom. to match rendering of pixel art in the game scene.
func SetPixelPerfectScale() -> void:
	for node in get_tree().current_scene.get_children():
		if node is Camera2D:
			scale = node.zoom
			return

func updateLevelLabel():
	levelText.UpdateLevelText()
