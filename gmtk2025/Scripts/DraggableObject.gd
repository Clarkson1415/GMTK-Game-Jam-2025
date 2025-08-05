extends Node2D

## Can drag and rotate.
class_name DraggableObject

## Added as a sub node for terminals and sources. Which will be dragging the parent.
@export var dragParent: bool = false

@export var areaForDragDetection: Area2D
@export var rotationTime = 0.2

var initialPos: Vector2
var underCursor: bool = false
var dragging: bool = false
var rPressed: bool = false

@export var highlightSprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	areaForDragDetection.mouse_entered.connect(onMouseEntered)
	areaForDragDetection.mouse_exited.connect(onMouseExit)
	snapToGrid()

func onMouseEntered():
	# if something is being dragged and its not this object
	if GlobalDragging.IsDragging():
		return;
	underCursor = true
	highlightSprite.visible = true

func onMouseExit():
	if dragging:
		return
	underCursor = false
	highlightSprite.visible = false

func _input(_event: InputEvent) -> void:
	if !underCursor:
		return;
	if !rPressed and Input.is_key_pressed(KEY_R) and !currentlyRotating:
		rPressed = true;
		GameSounds.PlayRotateSound()
		rotateOverTime(rotationTime)
	if !Input.is_key_pressed(KEY_R):
		rPressed = false;
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !GlobalDragging.IsDragging():
		print("Drag true")
		dragging = true
		GlobalDragging.ToggleDragging(true)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and dragging:
		print("Drag false")
		dragging = false
		GlobalDragging.ToggleDragging(false)
		highlightSprite.visible = false
		snapToGrid()

var currentlyRotating: bool = false;

func rotateOverTime(duration: float):
	currentlyRotating = true;
	var tween = create_tween()
	var target_rotation = getNodeToMove().rotation + PI/2
	tween.tween_property(getNodeToMove(), "rotation", target_rotation, duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(onRotationComplete)

func onRotationComplete():
	currentlyRotating = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if will_collide(get_global_mouse_position()):
		return
	if dragging:
		getNodeToMove().global_position = get_global_mouse_position()

func getNodeToMove():
	var nodeToDrag = get_parent() if dragParent else self
	return nodeToDrag

@export var areaCollisionShape: CollisionShape2D

func will_collide(nextPosition: Vector2) -> bool:
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = areaCollisionShape.shape
	query.transform = Transform2D(0, nextPosition)
	query.collision_mask = 1  # set based on what layers you want to collide with
	var result = get_world_2d().direct_space_state.intersect_shape(query)
	return result.size() > 0

func snapToGrid():
	getNodeToMove().global_position = (global_position / 16).round() * 16
