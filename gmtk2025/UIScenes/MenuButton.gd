extends Button

@export var anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_onPressed)
	button_down.connect(_onDown)
	button_up.connect(_onUp)
	mouse_entered.connect(_onHover)
	mouse_exited.connect(_onUnHover)

func _onUnHover():
	print("unhover")

func _onHover():
	print("hover")

func _onPressed():
	print("pressed")

func _onDown():
	anim.play(&"ButtonDown")
	print("Down")

func _onUp():
	anim.play(&"Default")
	print("UP")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
