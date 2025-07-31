extends Node2D

class_name DraggableObject

@onready var area_2d: Area2D = $Area2D
var bodyItsInside: StaticBody2D = null
@export var rotationTime = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.mouse_entered.connect(onMouseEntered)
	area_2d.mouse_exited.connect(onMouseExit)
	area_2d.body_entered.connect(onArea2DBodyEntered)
	area_2d.body_exited.connect(onArea2DBodyExited)
	snapToGrid()

func onMouseEntered():
	print("mouse mouse enter")
	scale = Vector2(1.05, 1.05)
	underCursor = true
	# TODO: more feeback like a highlight idk

func onMouseExit():
	print("mouse exit")
	underCursor = false
	scale = Vector2(1, 1)

func onArea2DBodyEntered(body: StaticBody2D):
	if body.is_in_group("dropable"):
		print("entered")
		bodyItsInside = body

func onArea2DBodyExited(body):
	# the area to drop on change col to indicate placing on this tile.
	if body.is_in_group("dropable"):
		print("exit")
		bodyItsInside = null

var initialPos: Vector2

var underCursor: bool = false
var dragging: bool = false
var rPressed: bool = false
func _input(event: InputEvent) -> void:
	if !underCursor:
		return;
	if !rPressed and Input.is_key_pressed(KEY_R) and !currentlyRotating:
		rPressed = true;
		rotateOverTime(rotationTime)
	if !Input.is_key_pressed(KEY_R):
		rPressed = false;
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = true
		initialPos = global_position
		global_position = get_global_mouse_position()
	else:
		dragging = false
		snapToGrid()

var currentlyRotating: bool = false;

func rotateOverTime(duration: float):
	currentlyRotating = true;
	var tween = create_tween()
	var target_rotation = rotation + PI/2
	tween.tween_property(self, "rotation", target_rotation, duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(onRotationComplete)

func onRotationComplete():
	currentlyRotating = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func snapToGrid():
	global_position = (global_position / 16).round() * 16
