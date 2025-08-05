extends PowerableArea

## Represents half a wire length. Powerable area with sprites.
class_name PowerableAreaVisible

@export var thisColour: WireColours.WireColour
@export var wireColourSprite: Sprite2D
@export var yellowLinesSprite: Sprite2D

func _ready() -> void:
	super._ready()
	yellowLinesSprite.modulate = WireColours.ACTIVEYELLOW
	wireColourSprite.modulate = WireColours.ColourArray[thisColour]

func turnON():
	super.turnON()
	yellowLinesSprite.visible = true

func turnOFF():
	super.turnOFF()
	yellowLinesSprite.visible = false

## Overrides base implementation because this has a colour to check.
func has_path_to_power(visited := {}) -> bool:
	if self in visited:
		return false
	visited[self] = true
	if isPowerSource:
		return true
	for neighbor in adjacentWires:
		if neighbor is PowerableAreaVisible:
			if neighbor.thisColour != thisColour:
				continue
		if neighbor.has_path_to_power(visited):
			return true
	return false

func _process(_delta: float) -> void:
	resetAdjacentList()
	if has_path_to_power():
		turnON()
	else:
		turnOFF()
