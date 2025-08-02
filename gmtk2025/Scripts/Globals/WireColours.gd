extends Node

@export var ColourArray: Dictionary[WireColour, Color] = {
	WireColour.green: Color("#1ae60b"), WireColour.blue: Color("#10b6e8")}

# pale green blue
# WireColour.green: Color("#669674"), WireColour.blue: Color("#4a92b8")}

var ACTIVEYELLOW: Color = Color.YELLOW

enum WireColour {blue, green}
