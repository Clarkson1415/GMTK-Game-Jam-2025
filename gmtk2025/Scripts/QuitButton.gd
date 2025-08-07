extends AbstractGameButton

## Overrides base button on pressed
func _virtualOnPressedBehvaiour():
	# TODO instead of quit do a quit to title screen
	get_tree().quit()

func _protectedAbstractOnPressed():
	get_tree().quit()
