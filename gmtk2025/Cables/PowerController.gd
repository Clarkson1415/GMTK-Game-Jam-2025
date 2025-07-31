extends Node2D

class_name PowerController
@export var area1: Array[PowerableArea]

var IsPowerSource: bool = false

signal PowerON
signal PowerOFF

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _toggleAllAreasSending(onOff: bool) -> void:
	for pa: PowerableArea in area1:
		pa.IsSendingPower = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if IsPowerSource:
		_toggleAllAreasSending(true)
		return
	var powerIsOn: bool = false;
	for pa: PowerableArea in area1:
		if pa.IsRecevingPower:
			powerIsOn = true;
	if powerIsOn:
		emit_signal("PowerON")
		_toggleAllAreasSending(true)
	else:
		emit_signal("PowerOFF")
		_toggleAllAreasSending(false)
