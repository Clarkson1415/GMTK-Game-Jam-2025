extends Node2D

class_name PowerController
@export var area2ds: Array[PowerableArea]

signal PowerON
signal PowerOFF

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var powerIsOn: bool = false;
	for pa: PowerableArea in area2ds:
		if pa.IsPowered():
			powerIsOn = true;
	if powerIsOn:
		emit_signal("PowerON")
	else:
		emit_signal("PowerOFF")
