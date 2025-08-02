extends Node

var _isDragging = false

func ToggleDragging(isDrag: bool):
	if _isDragging != isDrag:
		if isDrag:
			GameSounds.PlayPickupSound()
		else:
			GameSounds.PlayPlaceSound()
	_isDragging = isDrag

func IsDragging():
	return _isDragging
