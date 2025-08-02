extends Area2D

## Represents half a wire length.
class_name PowerableArea

@export var thisColour: WireColours.WireColour
@export var wireColourSprite: Sprite2D
@export var yellowLinesSprite: Sprite2D

var NAME
var PARENT

var _isPoweredReadonly

signal TURNOFFADJACENT
signal TURNONADJACENT

var adjacentWires: Array[PowerableArea]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NAME = self.name
	PARENT = self.get_parent().name
	wireColourSprite.self_modulate = WireColours.ColourArray[thisColour]
	yellowLinesSprite.self_modulate = Color.YELLOW
	turnOFF()
	area_exited.connect(_on_area_exited)
	area_entered.connect(_on_area_entered)
	resetAdjacentList()

func resetAdjacentList():
	for connectedArea in adjacentWires:
		connectedArea.TURNOFFADJACENT.disconnect(turnOFF)
		connectedArea.TURNONADJACENT.disconnect(turnON)
	adjacentWires.clear()
	for overlap in get_overlapping_areas():
		if overlap is PowerableArea:
			adjacentWires.append(overlap)
	for area: PowerableArea in adjacentWires:
		area.TURNOFFADJACENT.connect(turnOFF)
		area.TURNONADJACENT.connect(turnON)

func _on_area_exited(area: Area2D):
	resetAdjacentList()

func _on_area_entered(area: Area2D):
	resetAdjacentList()

func turnON():
	yellowLinesSprite.visible = true
	_isPoweredReadonly = true
	emit_signal("TURNONADJACENT")

func turnOFF():
	yellowLinesSprite.visible = false
	_isPoweredReadonly = false
	emit_signal("TURNOFFADJACENT")

func IsPowered():
	return _isPoweredReadonly

func _process(delta: float) -> void:
	if isTouchingPowerSource():
		turnON()

func isTouchingPowerSource() -> bool:
	var overlapping = get_overlapping_areas()
	for pa in overlapping:
		if pa is PowerSource:
			return true
	return false
