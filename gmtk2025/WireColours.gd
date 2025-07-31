extends Node

@export var colourArray: Dictionary[WireColour, Color] = {
	WireColour.green: Color("#669674"), WireColour.blue: Color("#4a92b8")}

var ACTIVEYELLOW: Color = Color.YELLOW

enum WireColour {blue, green}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
