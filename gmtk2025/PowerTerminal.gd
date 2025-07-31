extends Node2D
class_name PowerTerminal

@export var ON: bool

## Sprite to change colour.
@export var tileSprite: Sprite2D
@export var tileColour: WireColours.WireColour
@export var animationPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tileSprite.modulate = WireColours.colourArray[tileColour]
	if ON:
		animationPlayer.play(&"ON")
	else:
		animationPlayer.play(&"OFF")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
