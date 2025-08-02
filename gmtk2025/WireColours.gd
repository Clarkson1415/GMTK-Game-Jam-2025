extends Node

@export var ColourArray: Dictionary[WireColour, Color] = {
	WireColour.green: Color("#669674"), WireColour.blue: Color("#4a92b8")}

var ACTIVEYELLOW: Color = Color.YELLOW

enum WireColour {blue, green}
