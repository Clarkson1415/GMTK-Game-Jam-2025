extends Area2D

## Represents a powerable area without any sprites and outlines or colour.
class_name PowerableArea

## permanantly on.
@export var isPowerSource: bool = false

var NAME
var PARENT
var adjacentWires: Array[PowerableArea]

var IsPoweredReadonly: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_collision_layer_value(2, true)
	#set_collision_mask_value(2, true)
	#set_collision_layer_value(1, false)
	#set_collision_mask_value(1, false)
	#print("Reminder: Setting all wires to layer 2, mask 2. as invisible powerable areas must be connecting the visible and cannot be set in as as this are just a component not a scene.")
	NAME = self.name
	PARENT = self.get_parent().name
	resetAdjacentList()
	turnOFF()
	if isPowerSource:
		turnON()

func turnON():
	IsPoweredReadonly = true

func turnOFF():
	IsPoweredReadonly = false

func resetAdjacentList():
	adjacentWires.clear()
	for overlap in get_overlapping_areas():
		if overlap is PowerableArea and overlap != self:
			adjacentWires.append(overlap)

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
