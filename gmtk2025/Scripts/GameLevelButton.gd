extends AbstractGameButton

@export var labelComponent: Label
@export var level: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	labelComponent.text = str(level)

func _protectedAbstractOnPressed():
	GameSettings.LoadLevel(level)
