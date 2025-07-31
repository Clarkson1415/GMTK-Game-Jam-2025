extends Node2D
class_name PowerSource

## Initial power terminal state.
@export var ON: bool

## Sprite to change colour.
@export var tileSprite: Sprite2D
@export var tileColour: WireColours.WireColour
@export var animationPlayer: AnimationPlayer

@export var outlineSprite: Sprite2D
@export var powerController: PowerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tileSprite.modulate = WireColours.colourArray[tileColour]
	if ON:
		powerON()
		powerController.IsPowerSource = true
		outlineSprite.modulate = Color.YELLOW
	else:
		outlineSprite.modulate = Color.BLACK
		powerOFF()
	powerController.PowerON.connect(powerON)
	powerController.PowerOFF.connect(powerOFF)

func powerON():
	animationPlayer.play(&"ON")

func powerOFF():
	animationPlayer.play(&"OFF")
