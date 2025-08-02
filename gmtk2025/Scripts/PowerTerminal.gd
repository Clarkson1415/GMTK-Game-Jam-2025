extends Node2D

## Represents a terminal that can receive and transmit power. and must be powered to win.
class_name PowerTerminal

@export var yellowPowerIcon: Sprite2D
@export var area2ds: Array[PowerableArea]
@export var sparksAnimationPlayer: PowerAnimations

var isPowered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var powerIsOn: bool = false;
	for pa in area2ds:
		if pa.yellowLinesSprite.visible:
			powerIsOn = true;
	if powerIsOn and !isPowered:
		isPowered = true
		sparksAnimationPlayer._power_on()
		GameSounds.PlayElectricPulseSound()
		yellowPowerIcon.visible = true
	elif !powerIsOn and isPowered:
		isPowered = false
		GameSounds.PowerOff()
		sparksAnimationPlayer._power_off()
		yellowPowerIcon.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yellowPowerIcon.self_modulate = WireColours.ACTIVEYELLOW
	sparksAnimationPlayer._power_off()
