extends Area2D

var bodyItsInside: StaticBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#mouse_entered.connect(onMouseEntered)
	#mouse_exited.connect(onMouseExit)
	#area_entered.connect(onArea2DBodyEntered)
	#area_exited.connect(onArea2DBodyExited)
	pass

func onMouseEntered():
	scale = Vector2(1.05, 1.05)
	# TODO: more feeback like a highlight idk

func onMouseExit():
	scale = Vector2(1, 1)

var initialPos: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print("dragging")
		initialPos = global_position
		global_position = get_global_mouse_position()
	else:
		print("not dragging")
		var tween = get_tree().create_tween()
		if bodyItsInside != null:
			global_position = bodyItsInside.global_position
			# tween.tween_property(self, "position", bodyItsInside.position, 0.2).set_ease(Tween.EASE_OUT)
		else:
			pass
			# tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
