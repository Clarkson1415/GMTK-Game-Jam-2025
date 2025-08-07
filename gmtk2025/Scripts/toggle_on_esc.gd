extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameLevels.LevelChanged.connect(_onLevelChanged)

func _onLevelChanged():
	if isOpen:
		toggleMenu()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("openMenu"):
		toggleMenu()

var isOpen: = false

func toggleMenu():
	if isOpen:
		isOpen = false
		play("SlideOut")
	else:
		isOpen = true
		play("SlideIn")
