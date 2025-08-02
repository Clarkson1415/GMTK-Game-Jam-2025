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
	if isPowerSource:
		turnON()

func resetAdjacentList():
	adjacentWires.clear()
	for overlap in get_overlapping_areas():
		if overlap is PowerableArea and overlap != self:
			adjacentWires.append(overlap)

func _on_area_exited(area: Area2D):
	if self.get_parent().name == "END":
		print("end left.")
	var pa: PowerableArea = area as PowerableArea
	if pa == null:
		return
	# if removed area was powering this and no other adjacent areas are powersing it.?
	if pa.IsPowered():
		turnOFF_propagate()

func _on_area_entered(area: Area2D):
	if self.get_parent().name == "END":
		print("end left.")
	var pa: PowerableArea = area as PowerableArea
	if pa == null:
		return
	if pa.IsPowered() or pa.isPowerSource:
		turnON_propagate()

func turnON():
	yellowLinesSprite.visible = true
	_isPoweredReadonly = true

func turnOFF():
	yellowLinesSprite.visible = false
	_isPoweredReadonly = false

func IsPowered():
	return _isPoweredReadonly

func _process(delta: float) -> void:
	if isPowerSource:
		turnON_propagate()
		return
	resetAdjacentList()
	var isThisPowered = false
	for adj in adjacentWires:
		if adj.isPowerSource or adj.IsPowered():
			isThisPowered = true
	if isThisPowered:
		turnON_propagate()
	else:
		turnOFF_propagate()

## permanantly on.
@export var isPowerSource: bool = false

func turnOFF_propagate(visited := {}):
	resetAdjacentList()
	if isPowerSource:
		turnON()
		return
	if self in visited:
		return
	visited[self] = true
	_isPoweredReadonly = false
	yellowLinesSprite.visible = false
	# instead is the neighbour is powered dont remit
	print("")
	for neighbor in adjacentWires:
		neighbor.turnOFF_propagate(visited)

func turnON_propagate(visited := {}):
	resetAdjacentList()
	if self in visited:
		return
	visited[self] = true
	_isPoweredReadonly = true
	yellowLinesSprite.visible = true
	# instead is the neighbour is powered dont remit
	print("")
	for neighbor in adjacentWires:
		neighbor.turnON_propagate(visited)
