extends Area2D

## Represents half a wire length.
class_name PowerableArea

@export var thisColour: WireColours.WireColour
@export var wireColourSprite: Sprite2D
@export var yellowLinesSprite: Sprite2D

## permanantly on.
@export var isPowerSource: bool = false

var NAME
var PARENT

var adjacentWires: Array[PowerableArea]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NAME = self.name
	PARENT = self.get_parent().name
	wireColourSprite.self_modulate = WireColours.ColourArray[thisColour]
	yellowLinesSprite.self_modulate = Color.YELLOW
	resetAdjacentList()
	turnOFF()
	if isPowerSource:
		turnON()

func resetAdjacentList():
	adjacentWires.clear()
	for overlap in get_overlapping_areas():
		if overlap is PowerableArea and overlap != self:
			adjacentWires.append(overlap)

func turnON():
	yellowLinesSprite.visible = true

func turnOFF():
	yellowLinesSprite.visible = false

func has_path_to_power(visited := {}) -> bool:
	if self in visited:
		return false
	visited[self] = true
	if isPowerSource:
		return true
	for neighbor in adjacentWires:
		if neighbor.has_path_to_power(visited):
			return true
	return false

func _process(_delta: float) -> void:
	resetAdjacentList()
	if has_path_to_power():
		turnON()
	else:
		turnOFF()
