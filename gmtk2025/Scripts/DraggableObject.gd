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
	var isLeftMouseButtonPressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if underCursor and Input.is_key_pressed(KEY_R) and !currentlyRotating:
		print("before rotation angle  = " + str(getNodeToMove().global_rotation))
		print("rotation to check  = " + str(getNodeToMove().global_rotation + (PI/2)))
		var willCollide = await will_collide(getNodeToMove().global_position, getNodeToMove().global_rotation + (PI/2))
		print("rotation will collide = " + str(willCollide))
		if !dragging and willCollide:
			return
		GameSounds.PlayRotateSound()
		rotateOverTime(rotationTime)
		return
	if !underCursor:
		highlightSprite.visible = false
		return
	if !isLeftMouseButtonPressed and dragging:
		print("Drag false")
		dragging = false
		GlobalDragging.ToggleDragging(false)
		snapToGrid()
		return
	if isLeftMouseButtonPressed and !GlobalDragging.IsDragging():
		print("Drag true")
		dragging = true
		GlobalDragging.ToggleDragging(true)

var currentlyRotating: bool = false;

func rotateOverTime(duration: float):
	currentlyRotating = true;
	var tween = create_tween()
	var target_rotation = roundRotation(getNodeToMove().global_rotation) + PI/2
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
	## OLD: this is if want to follow constantly
	#if await will_collide(newPosition):
		#print("set to last legal = " + str(lastLegalPosition))
		#getNodeToMove().global_position = lastLegalPosition
		## THIS SHOULD ALWAYS BE FALSE:
		#print("Will collide at lastLegalPosition = " + str(await will_collide(lastLegalPosition)))
		#return
	#if dragging:
		#getNodeToMove().global_position = newPosition
		#lastLegalPosition = newPosition
		#print("set to new legal = " + str(newPosition))

func getNodeToMove() -> Node2D:
	var nodeToDrag = get_parent() if dragParent else self
	return nodeToDrag

func willCollideWithWallsFunction(transformsToCheck: Array[Transform2D]) -> bool:
	var areaCollisionShapes: Array[CollisionShape2D] = getDraggableAreasCollisionShape()
	for i in range(len(areaCollisionShapes)):
		if willShapeCollideWithWall(transformsToCheck[i], areaCollisionShapes[i]):
			return true
	return false

func willShapeCollideWithWall(transToChech: Transform2D, areaCollisionShape: CollisionShape2D) -> bool:
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = areaCollisionShape.shape
	query.transform = transToChech
	query.collision_mask = 4
	var result = get_world_2d().direct_space_state.intersect_shape(query)
	return result.size() > 0

func getDraggableAreasCollisionShape() -> Array[CollisionShape2D]:
	var areaCollisionShape: Array[CollisionShape2D]
	for child in areaForDragDetection.get_children():
		if child is CollisionShape2D:
			areaCollisionShape.append(child)
	if areaCollisionShape == null:
		push_error("Area collision shape not found on: " + self.name)
	return areaCollisionShape

func createTransformsToCheck(nextPositionGlobal: Vector2, nextRotationGlobalRads: float) -> Array[Transform2D]:
	var areasCollisionShapes: Array[CollisionShape2D] = getDraggableAreasCollisionShape()
	var transformsToCheck: Array[Transform2D]
	for collisionShape in areasCollisionShapes:
		var transform = createATransformToCheck(collisionShape, nextPositionGlobal, nextRotationGlobalRads)
		transformsToCheck.append(transform)
	return transformsToCheck

func createATransformToCheck(areasCollisionShape: CollisionShape2D, nextPositionGlobal: Vector2, nextRotationGlobalRads: float) -> Transform2D:
	#var parent_transform = Transform2D(nextRotationGlobalRads, nextPositionGlobal)
	#var combined_local_transform = areasCollisionShape.transform
	#var final_transform = parent_transform * combined_local_transform
	print("areasCollisionShape.transform: ", areasCollisionShape.transform)
	var rotated_offset = areasCollisionShape.transform.origin.rotated(nextRotationGlobalRads)
	var final_position = rotated_offset + nextPositionGlobal
	var final_rotation = nextRotationGlobalRads + areasCollisionShape.transform.get_rotation()
	var final_transform = Transform2D(final_rotation, final_position)
	var local_transform = get_global_transform().affine_inverse() * final_transform
	return final_transform

func willCollideWithArea(nextPositionGlobal, nextRotationGlobalRads) -> bool:
	var previousPos = areaForDragDetection.global_position
	var previousRotation = areaForDragDetection.global_rotation
	var areaTransformedToNewPosition: Transform2D = Transform2D(nextRotationGlobalRads, nextPositionGlobal)
	PhysicsServer2D.area_set_transform(areaForDragDetection.get_rid(), areaTransformedToNewPosition)
	await get_tree().physics_frame
	# await get_tree().physics_frame
	# await get_tree().process_frame  # Wait one frame to let physics server update
	var overlappedAreas = areaForDragDetection.get_overlapping_areas()
	var overlappedAreaOnMask = overlappedAreas.filter(func(area):
		return area.collision_layer & areaForDragDetection.collision_mask != 0)
	var areasInWay = !overlappedAreaOnMask.is_empty()
	for areas in overlappedAreaOnMask:
		print("overlapping Area = ", areas.name)
	PhysicsServer2D.area_set_transform(areaForDragDetection.get_rid(), Transform2D(previousRotation, previousPos))
	return areasInWay

func will_collide(nextPositionGlobal: Vector2, nextRotationGlobalRads: float) -> bool:
	var transformsToCheck: Array[Transform2D] = createTransformsToCheck(nextPositionGlobal, nextRotationGlobalRads)
	var willCollideWithWalls = willCollideWithWallsFunction(transformsToCheck)
	var willCollideWithArea = await willCollideWithArea(nextPositionGlobal, nextRotationGlobalRads)
	return willCollideWithWalls or willCollideWithArea

func snapToGrid() -> void:
	var firstCoordinatesToCheck = (global_position / 16).round() * 16
	var maxRadius = 15  # How far out to search (in grid units
	# set rotation wait 2 phyrics updates
	var roundedRot = roundRotation(getNodeToMove().global_rotation)
	getNodeToMove().global_rotation = roundedRot
	# snap position.
	for radius in range(maxRadius + 1):
		for offset in get_grid_offsets_at_radius(radius):
			var tryPos = firstCoordinatesToCheck + offset * 16
			if not await will_collide(tryPos, getNodeToMove().global_rotation):
				getNodeToMove().global_position = tryPos
				print("Snapped to legal position: ", tryPos)
				return
	print("Could not find a legal snap position near ", firstCoordinatesToCheck)

func roundRotation(rotation_radians: float) -> float:
	var ninety_deg = PI / 2
	return round(rotation_radians / ninety_deg) * ninety_deg

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
