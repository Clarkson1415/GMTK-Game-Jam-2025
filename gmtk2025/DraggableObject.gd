extends Node2D

## Can drag and rotate. To put wire stuff in another script
class_name DraggableObject

@export var areaForDragDetection: Area2D
var bodyItsInside: StaticBody2D = null
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
	areaForDragDetection.body_entered.connect(onArea2DBodyEntered)
	areaForDragDetection.body_exited.connect(onArea2DBodyExited)
	snapToGrid()

func onMouseEntered():
	# if something is being dragged and its not this object
	if Global.isDraggingGlobal:
		return; 
	underCursor = true
	highlightSprite.visible = true

func onMouseExit():
	underCursor = false
	highlightSprite.visible = false

func onArea2DBodyEntered(body: StaticBody2D):
	if body.is_in_group("dropable"):
		bodyItsInside = body

func onArea2DBodyExited(body):
	# the area to drop on change col to indicate placing on this tile.
	if body.is_in_group("dropable"):
		bodyItsInside = null

func _input(event: InputEvent) -> void:
	if !underCursor:
		return;
	if !rPressed and Input.is_key_pressed(KEY_R) and !currentlyRotating:
		rPressed = true;
		rotateOverTime(rotationTime)
	if !Input.is_key_pressed(KEY_R):
		rPressed = false;
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !Global.isDraggingGlobal:
		dragging = true
		Global.isDraggingGlobal = true
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		Global.isDraggingGlobal = false
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
	if will_collide(get_global_mouse_position()):
		dragging = false
		Global.isDraggingGlobal = false
		snapToGrid()
	if dragging:
		global_position = get_global_mouse_position()

@export var areaCollisionShape: CollisionShape2D

func will_collide(position: Vector2) -> bool:
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = areaCollisionShape.shape
	query.transform = Transform2D(0, position)
	query.collision_mask = 1  # set based on what layers you want to collide with
	var result = get_world_2d().direct_space_state.intersect_shape(query)
	return result.size() > 0

func snapToGrid():
	global_position = (global_position / 16).round() * 16
