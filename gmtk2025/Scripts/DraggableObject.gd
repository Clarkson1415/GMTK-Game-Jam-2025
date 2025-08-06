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
	var isLeftMouseButtonPressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if !rPressed and Input.is_key_pressed(KEY_R) and !currentlyRotating and !will_collide(getNodeToMove().global_position, getNodeToMove().global_rotation + (PI/2)):
		rPressed = true;
		GameSounds.PlayRotateSound()
		rotateOverTime(rotationTime)
	if !Input.is_key_pressed(KEY_R):
		rPressed = false;
	if isLeftMouseButtonPressed and !GlobalDragging.IsDragging():
		print("Drag true")
		dragging = true
		GlobalDragging.ToggleDragging(true)
	elif !isLeftMouseButtonPressed and dragging:
		print("Drag false")
		dragging = false
		GlobalDragging.ToggleDragging(false)
		highlightSprite.visible = false
		snapToGrid()

var currentlyRotating: bool = false;

func rotateOverTime(duration: float):
	currentlyRotating = true;
	var tween = create_tween()
	var target_rotation = getNodeToMove().global_rotation + PI/2
	tween.tween_property(getNodeToMove(), "global_rotation", target_rotation, duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(onRotationComplete)

func onRotationComplete():
	currentlyRotating = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !dragging:
		return
	var newPosition = get_global_mouse_position()
	# Allow to follow but when released it will snap to legal square in grid.
	getNodeToMove().global_position = newPosition
	#if await will_collide(newPosition):
		#print("set to last legal = " + str(lastLegalPosition))
		#getNodeToMove().global_position = lastLegalPosition
		## THIS SHOULD ALWAYS BE FALSE
		#print("Will collide at lastLegalPosition = " + str(await will_collide(lastLegalPosition)))
		#return
	#if dragging:
		#getNodeToMove().global_position = newPosition
		#lastLegalPosition = newPosition
		#print("set to new legal = " + str(newPosition))

func getNodeToMove() -> Node2D:
	var nodeToDrag = get_parent() if dragParent else self
	return nodeToDrag

var debug_shapes = []

func willCollideWithWalls(nextPosition: Vector2, nextRotationGlobalRads: float) -> bool:
	var query = PhysicsShapeQueryParameters2D.new()
	var areaCollisionShape: CollisionShape2D = null
	for child in areaForDragDetection.get_children():
		if child is CollisionShape2D:
			areaCollisionShape = child
	if areaCollisionShape == null:
		push_error("Area collision shape not found on: " + self.name)
	query.shape = areaCollisionShape.shape
	var rotationAngle = nextRotationGlobalRads
	var shape_offset: Vector2 = areaCollisionShape.position
	var global_position_to_test = nextPosition + shape_offset.rotated(rotationAngle)
	query.transform = Transform2D(rotationAngle, global_position_to_test)
	query.collision_mask = 4
	# Save debug info for drawing later
	debug_shapes.clear()
	debug_shapes.append({
		"rotation": rotationAngle,
		"position": shape_offset,
		"shape": areaCollisionShape.shape,
		"color": Color(0, 1, 0, 0.3)
	})
	queue_redraw()  # Request redraw
	var result = get_world_2d().direct_space_state.intersect_shape(query)
	return result.size() > 0

func _draw():
	for shape_info in debug_shapes:
		drawDebugShapeCheck(shape_info["rotation"], shape_info["position"], shape_info["shape"], shape_info["color"])

func drawDebugShapeCheck(localRot: float, offset: Vector2, shape: Shape2D, color: Color):
	var transform = Transform2D(0, offset)
	if shape is RectangleShape2D:
		var rect_size = shape.extents * 2
		var half_size = rect_size / 2
		var points = [
			Vector2(-half_size.x, -half_size.y),
			Vector2(half_size.x, -half_size.y),
			Vector2(half_size.x, half_size.y),
			Vector2(-half_size.x, half_size.y),
		]
		for i in range(points.size()):
			points[i] = transform * points[i]
		draw_colored_polygon(points, color)
		draw_polyline(points + [points[0]], color.darkened(0.5), 2)

func will_collide(nextPositionGlobal: Vector2, nextRotationGlobalRads: float) -> bool:
	#var previousPos = areaForDragDetection.global_position
	#var rotationAngle = getNodeToMove().global_rotation
	#PhysicsServer2D.area_set_transform(areaForDragDetection.get_rid(), Transform2D(rotationAngle, nextPosition))
	#await get_tree().process_frame  # Wait one frame to let physics server update
	#var overlappedAreas = areaForDragDetection.get_overlapping_areas()
	#var overlappedAreaOnMask = overlappedAreas.filter(func(area):
		#return area.collision_layer & areaForDragDetection.collision_mask != 0)
	#var canDragToPosition = overlappedAreaOnMask.is_empty()
	#print("AREAS tested at = ", nextPosition)
	#print("AREAS OVERLAPPING = ", !canDragToPosition)
	#for areas in overlappedAreaOnMask:
		#print("overlapping Area = ", areas.name)
	#PhysicsServer2D.area_set_transform(areaForDragDetection.get_rid(), Transform2D(rotationAngle, previousPos))
	return willCollideWithWalls(nextPositionGlobal, nextRotationGlobalRads)# or !canDragToPosition

func snapToGrid() -> void:
	var startSnap = (global_position / 16).round() * 16
	var maxRadius = 15  # How far out to search (in grid units)
	for radius in range(maxRadius + 1):
		for offset in get_grid_offsets_at_radius(radius):
			var tryPos = startSnap + offset * 16
			if not await will_collide(tryPos, getNodeToMove().global_rotation):
				getNodeToMove().global_position = tryPos
				print("Snapped to legal position: ", tryPos)
				return
	print("Could not find a legal snap position near ", startSnap)

# Helper to generate offsets in square rings (Manhattan distance from center)
func get_grid_offsets_at_radius(r: int) -> Array[Vector2]:
	var offsets: Array[Vector2] = []
	if r == 0:
		offsets.append(Vector2(0, 0))
	else:
		for x in range(-r, r + 1):
			offsets.append(Vector2(x, -r))
			offsets.append(Vector2(x, r))
		for y in range(-r + 1, r):
			offsets.append(Vector2(-r, y))
			offsets.append(Vector2(r, y))
	return offsets
