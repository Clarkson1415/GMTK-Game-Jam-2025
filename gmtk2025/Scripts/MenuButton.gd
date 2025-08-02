extends Button

class_name AbstractGameButton

@export var anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_onPressed)
	button_down.connect(_onDown)
	button_up.connect(_onUp)
	mouse_entered.connect(_onHover)
	mouse_exited.connect(_onUnHover)

func _onUnHover():
	anim.play(&"Default")
	print("Unhover")

func _onHover():
	anim.play(&"Hover")
	print("Hover")

func _onPressed():
	anim.play(&"ButtonDown")
	_protectedAbstractOnPressed()

func _protectedAbstractOnPressed():
	push_error("Abstract game button on pressed behaviour not implemented on " + self.name)

func _onDown():
	anim.play(&"ButtonDown")
	print("Down")

func _onUp():
	anim.play(&"Hover")
	print("UP")
