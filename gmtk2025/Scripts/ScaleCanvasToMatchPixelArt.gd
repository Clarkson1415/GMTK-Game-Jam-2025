extends CanvasLayer

## Scales canvas by camera zoom. to match rendering of pixel art in the game scene.
class_name ScaleCanvasToMatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_tree().current_scene.get_children():
		if node is Camera2D:
			scale = node.zoom
			return
